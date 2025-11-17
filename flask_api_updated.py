from flask import Flask, request, jsonify,render_template
from flask_cors import CORS
import torch
import torch.nn as nn
from torchvision import transforms, models
from PIL import Image
import pandas as pd
import numpy as np
from sklearn.preprocessing import OneHotEncoder
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import io
import base64
import torch.nn.functional as F

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

# Load the models
skin_type_model = torch.load(
    'skin_type_model_complete.pth',
    map_location=torch.device('cpu'),
    weights_only=False,
)
skin_type_model.eval()

concern_model = models.resnet101(weights=None)
concern_model.fc = nn.Linear(concern_model.fc.in_features, 4)
state_dict = torch.load(r"best_model_concern.pth", map_location=device)
concern_model.load_state_dict(state_dict)
concern_model.eval()
concern_model.to(device)

# Load the product data
skincare_products_df = pd.read_csv('Skincare_Products.csv')
skincare_products_df = skincare_products_df.dropna(subset=['Concern List_'])

# Preprocess for recommendation system
skincare_products_df[['Skin Type']] = skincare_products_df[['Skin Type']].fillna('Normal')
encoder_skin = OneHotEncoder(sparse_output=False)

skin_type_encoded = encoder_skin.fit_transform(skincare_products_df[['Skin Type']])
skin_type_columns = encoder_skin.categories_[0]
skin_type_df = pd.DataFrame(skin_type_encoded, columns=skin_type_columns)

all_concerns = ['Acne', 'Bags', 'Enlarged pores', 'Redness']
concern_df = pd.DataFrame(0, index=skincare_products_df.index, columns=all_concerns)

for idx, concerns in enumerate(skincare_products_df['Concern List_']):
    if concerns:
        for concern in concerns.split(', '):
            if concern in concern_df.columns:
                concern_df.at[idx, concern] = 1

# TF-IDF for ingredients
tfidf_vectorizer = TfidfVectorizer(stop_words='english')
ingredients_tfidf = tfidf_vectorizer.fit_transform(skincare_products_df['ingredients'])

skin_type_labels = ["Dry", "Normal", "Oily"]

def preprocess_image(image):
    if hasattr(image, 'mode') and image.mode != 'RGB':
        image = image.convert('RGB')

    preprocess = transforms.Compose([
        transforms.Resize(256),
        transforms.CenterCrop(224),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
    ])
    image = preprocess(image).unsqueeze(0)
    return image

def recommend_products(user_skin_type, user_concern, ingredients_tfidf):
    user_skin_type_encoded = encoder_skin.transform([[user_skin_type]])
    
    user_concern_vector = np.zeros(len(all_concerns))
    for concern in user_concern.split(', '):
        if concern in all_concerns:
            user_concern_vector[all_concerns.index(concern)] = 1

    user_vector = np.concatenate([user_skin_type_encoded.flatten(), user_concern_vector])

    skin_similarity = cosine_similarity([user_vector[:len(user_skin_type_encoded.flatten())]], skin_type_df)
    concern_similarity = cosine_similarity([user_vector[len(user_skin_type_encoded.flatten()):]], concern_df)

    combined_similarity = 0.3 * skin_similarity + 0.7 * concern_similarity

    user_ingredients_tfidf = tfidf_vectorizer.transform([user_concern])
    ingredient_similarity = cosine_similarity(user_ingredients_tfidf, ingredients_tfidf)

    final_similarity = 0.6 * combined_similarity + 0.4 * ingredient_similarity

    recommended_indices = final_similarity.argsort()[0][-5:][::-1]

    recommended_products = skincare_products_df.iloc[recommended_indices]

    return recommended_products[['product_name', 'product_url', 'product_type', 'price']]

@app.route('/', methods=['GET'])
def home():
    return jsonify({
        'message': 'Skincare Product Recommendation API',
        'endpoints': {
            '/recommend': 'POST - Upload image for skin analysis and product recommendations',
            '/health': 'GET - Check API health status'
        }
    }), 200

@app.route('/recommend', methods=['POST'])
def recommend():
    try:
        # Check if image is in the request
        if 'image' not in request.files:
            return jsonify({'error': 'No image file provided'}), 400
        
        file = request.files['image']
        
        if file.filename == '':
            return jsonify({'error': 'No selected file'}), 400
        
        # Read and process the image
        image = Image.open(file.stream)
        
        # Predict skin type
        image_input = preprocess_image(image)
        with torch.no_grad():
            skin_type_output = skin_type_model(image_input)
            # حساب confidence من softmax probabilities
            skin_type_probs = F.softmax(skin_type_output, dim=1)
            skin_type_prediction = torch.argmax(skin_type_output, dim=1).item()
            skin_type_confidence = skin_type_probs[0][skin_type_prediction].item()
        
        skin_type = skin_type_labels[skin_type_prediction]
        
        # Predict concern
        with torch.no_grad():
            concern_output = concern_model(image_input.to(device))
            # حساب confidence من softmax probabilities
            concern_probs = F.softmax(concern_output, dim=1)
            concern_prediction = torch.argmax(concern_output, dim=1).item()
            concern_confidence = concern_probs[0][concern_prediction].item()
            concern = all_concerns[concern_prediction]
        
        # Get recommendations
        recommended_products = recommend_products(skin_type, concern, ingredients_tfidf)
        
        # Convert to dictionary format
        products_list = []
        for index, row in recommended_products.iterrows():
            products_list.append({
                'product_name': row['product_name'],
                'product_url': row['product_url'],
                'product_type': row['product_type'],
                'price': str(row['price'])
            })
        
        # Return JSON response مع confidence
        return jsonify({
            'success': True,
            'skin_type': skin_type,
            'concern': concern,
            'confidence': {
                'skin_type_confidence': round(skin_type_confidence, 4),
                'concern_confidence': round(concern_confidence, 4)
            },
            'recommended_products': products_list
        }), 200
    
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500

@app.route('/health', methods=['GET'])
def health():
    return jsonify({
        'status': 'healthy',
        'message': 'API is running successfully'
    }), 200

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)

