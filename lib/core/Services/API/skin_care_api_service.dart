import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

/// API service for skin analysis and recommendations
class SkinCareApiService {
  static const String baseUrl = "http://127.0.0.1:5000"; // Flask API URL

  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      "Accept": "application/json",
      "Content-Type": "multipart/form-data",
    },
  ));

  /// Check server status
  Future<bool> checkServerStatus() async {
    try {
      final response = await _dio.get('/health');
      if (response.statusCode == 200) {
        final data = response.data;
        return data['status'] == 'healthy' &&
            data['models_loaded'] == true &&
            data['data_loaded'] == true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Analyze skin only
  Future<SkinAnalysisResult> analyzeSkin({
    required XFile imageFile,
  }) async {
    try {
      // Convert XFile to File
      final file = File(imageFile.path);

      // Create FormData for image
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          file.path,
          filename: imageFile.name,
        ),
      });

      // Send request to API
      final response = await _dio.post(
        '/analyze',
        data: formData,
        options: Options(
          validateStatus: (status) =>
              status! < 500, // Allow status codes less than 500
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        return SkinAnalysisResult(
          skinType: data['skin_type'] as String? ?? 'Unknown',
          concern: data['concern'] as String? ?? 'Unknown',
          confidence: ConfidenceData.fromJson(data['confidence'] ?? {}),
          isSuccess: true,
          errorMessage: null,
        );
      } else {
        return SkinAnalysisResult(
          skinType: 'Unknown',
          concern: 'Unknown',
          confidence: ConfidenceData.empty(),
          isSuccess: false,
          errorMessage:
              'Failed to analyze image. Error code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Connection error occurred';

      if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout. Make sure server is running';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Receive timeout';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage =
            'Connection error. Make sure Flask API is running on port 5000';
      } else if (e.response?.statusCode != null) {
        errorMessage = 'Server error: ${e.response?.statusCode}';
      }

      return SkinAnalysisResult(
        skinType: 'Unknown',
        concern: 'Unknown',
        confidence: ConfidenceData.empty(),
        isSuccess: false,
        errorMessage: errorMessage,
      );
    } catch (e) {
      return SkinAnalysisResult(
        skinType: 'Unknown',
        concern: 'Unknown',
        confidence: ConfidenceData.empty(),
        isSuccess: false,
        errorMessage: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// Get recommendations based on skin type and concern
  Future<ProductRecommendationResult> getRecommendations({
    required String skinType,
    required String concern,
  }) async {
    try {
      final response = await _dio.post(
        '/recommend',
        data: {
          'skin_type': skinType,
          'concern': concern,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final recommendations = <ProductRecommendation>[];

        if (data['recommendations'] != null) {
          for (var item in data['recommendations']) {
            recommendations.add(ProductRecommendation.fromJson(item));
          }
        }

        return ProductRecommendationResult(
          recommendations: recommendations,
          skinType: data['skin_type'] as String? ?? skinType,
          concern: data['concern'] as String? ?? concern,
          isSuccess: true,
          errorMessage: null,
        );
      } else {
        return ProductRecommendationResult(
          recommendations: [],
          skinType: skinType,
          concern: concern,
          isSuccess: false,
          errorMessage:
              'Failed to get recommendations. Error code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Connection error occurred';

      if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout. Make sure server is running';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Receive timeout';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage =
            'Connection error. Make sure Flask API is running on port 5000';
      } else if (e.response?.statusCode != null) {
        errorMessage = 'Server error: ${e.response?.statusCode}';
      }

      return ProductRecommendationResult(
        recommendations: [],
        skinType: skinType,
        concern: concern,
        isSuccess: false,
        errorMessage: errorMessage,
      );
    } catch (e) {
      return ProductRecommendationResult(
        recommendations: [],
        skinType: skinType,
        concern: concern,
        isSuccess: false,
        errorMessage: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// Analyze image and get recommendations in one request
  Future<CompleteAnalysisResult> analyzeAndRecommend({
    required XFile imageFile,
  }) async {
    try {
      // Convert XFile to File
      final file = File(imageFile.path);

      // Create FormData for image
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          file.path,
          filename: imageFile.name,
        ),
      });

      // Send request to API
      final response = await _dio.post(
        '/analyze_and_recommend',
        data: formData,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final recommendations = <ProductRecommendation>[];

        if (data['recommendations'] != null) {
          for (var item in data['recommendations']) {
            recommendations.add(ProductRecommendation.fromJson(item));
          }
        }

        return CompleteAnalysisResult(
          skinType: data['skin_type'] as String? ?? 'Unknown',
          concern: data['concern'] as String? ?? 'Unknown',
          confidence: ConfidenceData.fromJson(data['confidence'] ?? {}),
          recommendations: recommendations,
          isSuccess: true,
          errorMessage: null,
        );
      } else {
        return CompleteAnalysisResult(
          skinType: 'Unknown',
          concern: 'Unknown',
          confidence: ConfidenceData.empty(),
          recommendations: [],
          isSuccess: false,
          errorMessage:
              'Failed to analyze image and get recommendations. Error code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Connection error occurred';

      if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timeout. Make sure server is running';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Receive timeout';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage =
            'Connection error. Make sure Flask API is running on port 5000';
      } else if (e.response?.statusCode != null) {
        errorMessage = 'Server error: ${e.response?.statusCode}';
      }

      return CompleteAnalysisResult(
        skinType: 'Unknown',
        concern: 'Unknown',
        confidence: ConfidenceData.empty(),
        recommendations: [],
        isSuccess: false,
        errorMessage: errorMessage,
      );
    } catch (e) {
      return CompleteAnalysisResult(
        skinType: 'Unknown',
        concern: 'Unknown',
        confidence: ConfidenceData.empty(),
        recommendations: [],
        isSuccess: false,
        errorMessage: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// Get server information
  Future<ServerInfo> getServerInfo() async {
    try {
      final response = await _dio.get('/');

      if (response.statusCode == 200) {
        final data = response.data;
        return ServerInfo(
          message: data['message'] as String? ??
              'Welcome to Skin Care Product Recommendation System',
          endpoints: Map<String, String>.from(data['endpoints'] ?? {}),
          isSuccess: true,
          errorMessage: null,
        );
      } else {
        return ServerInfo(
          message: '',
          endpoints: {},
          isSuccess: false,
          errorMessage: 'Failed to get server information',
        );
      }
    } catch (e) {
      return ServerInfo(
        message: '',
        endpoints: {},
        isSuccess: false,
        errorMessage: 'Server connection error: ${e.toString()}',
      );
    }
  }
}

/// Data model for skin analysis result
class SkinAnalysisResult {
  final String skinType;
  final String concern;
  final ConfidenceData confidence;
  final bool isSuccess;
  final String? errorMessage;

  SkinAnalysisResult({
    required this.skinType,
    required this.concern,
    required this.confidence,
    required this.isSuccess,
    this.errorMessage,
  });

  /// Check if operation was successful
  bool get isSuccessful => isSuccess && errorMessage == null;

  /// Get skin type in Arabic
  String get skinTypeArabic {
    switch (skinType.toLowerCase()) {
      case 'oily':
        return 'دهنية';
      case 'dry':
        return 'جافة';
      case 'normal':
        return 'عادية';
      default:
        return 'غير معروف';
    }
  }

  /// Get concern in Arabic
  String get concernArabic {
    switch (concern.toLowerCase()) {
      case 'acne':
        return 'حب الشباب';
      case 'bags':
        return 'الهالات السوداء';
      case 'enlarged pores':
        return 'المسام الواسعة';
      case 'redness':
        return 'الاحمرار';
      default:
        return 'غير معروف';
    }
  }

  @override
  String toString() {
    return 'SkinAnalysisResult(skinType: $skinType, concern: $concern, isSuccess: $isSuccess)';
  }
}

/// Data model for confidence in results
class ConfidenceData {
  final double skinTypeConfidence;
  final double concernConfidence;

  ConfidenceData({
    required this.skinTypeConfidence,
    required this.concernConfidence,
  });

  factory ConfidenceData.fromJson(Map<String, dynamic> json) {
    return ConfidenceData(
      skinTypeConfidence:
          (json['skin_type_confidence'] as num?)?.toDouble() ?? 0.0,
      concernConfidence:
          (json['concern_confidence'] as num?)?.toDouble() ?? 0.0,
    );
  }

  factory ConfidenceData.empty() {
    return ConfidenceData(
      skinTypeConfidence: 0.0,
      concernConfidence: 0.0,
    );
  }

  /// Get confidence percentage as text
  String get skinTypeConfidencePercentage =>
      (skinTypeConfidence * 100).toStringAsFixed(1);

  String get concernConfidencePercentage =>
      (concernConfidence * 100).toStringAsFixed(1);

  @override
  String toString() {
    return 'ConfidenceData(skinType: ${skinTypeConfidencePercentage}%, concern: ${concernConfidencePercentage}%)';
  }
}

/// Data model for product recommendation
class ProductRecommendation {
  final String productName;
  final String productUrl;
  final String productType;
  final String price;

  ProductRecommendation({
    required this.productName,
    required this.productUrl,
    required this.productType,
    required this.price,
  });

  factory ProductRecommendation.fromJson(Map<String, dynamic> json) {
    return ProductRecommendation(
      productName: json['product_name'] as String? ?? '',
      productUrl: json['product_url'] as String? ?? '',
      productType: json['product_type'] as String? ?? '',
      price: json['price'] as String? ?? '',
    );
  }

  /// Get product type in Arabic
  String get productTypeArabic {
    switch (productType.toLowerCase()) {
      case 'exfoliator':
        return 'مقشر';
      case 'balm':
        return 'مرهم';
      case 'bath oil':
        return 'زيت حمام';
      case 'body wash':
        return 'غسول الجسم';
      case 'cleanser':
        return 'منظف';
      case 'moisturizer':
        return 'مرطب';
      case 'serum':
        return 'سيروم';
      case 'toner':
        return 'تونر';
      case 'mask':
        return 'قناع';
      case 'sunscreen':
        return 'واقي شمس';
      default:
        return productType;
    }
  }

  @override
  String toString() {
    return 'ProductRecommendation(name: $productName, type: $productType, price: $price)';
  }
}

/// Data model for recommendation results
class ProductRecommendationResult {
  final List<ProductRecommendation> recommendations;
  final String skinType;
  final String concern;
  final bool isSuccess;
  final String? errorMessage;

  ProductRecommendationResult({
    required this.recommendations,
    required this.skinType,
    required this.concern,
    required this.isSuccess,
    this.errorMessage,
  });

  /// Check if operation was successful
  bool get isSuccessful => isSuccess && errorMessage == null;

  /// Get number of recommendations
  int get recommendationCount => recommendations.length;

  @override
  String toString() {
    return 'ProductRecommendationResult(count: $recommendationCount, isSuccess: $isSuccess)';
  }
}

/// Data model for complete analysis with recommendations
class CompleteAnalysisResult {
  final String skinType;
  final String concern;
  final ConfidenceData confidence;
  final List<ProductRecommendation> recommendations;
  final bool isSuccess;
  final String? errorMessage;

  CompleteAnalysisResult({
    required this.skinType,
    required this.concern,
    required this.confidence,
    required this.recommendations,
    required this.isSuccess,
    this.errorMessage,
  });

  /// Check if operation was successful
  bool get isSuccessful => isSuccess && errorMessage == null;

  /// Get number of recommendations
  int get recommendationCount => recommendations.length;

  @override
  String toString() {
    return 'CompleteAnalysisResult(skinType: $skinType, concern: $concern, recommendations: $recommendationCount)';
  }
}

/// Data model for server information
class ServerInfo {
  final String message;
  final Map<String, String> endpoints;
  final bool isSuccess;
  final String? errorMessage;

  ServerInfo({
    required this.message,
    required this.endpoints,
    required this.isSuccess,
    this.errorMessage,
  });

  /// التحقق من نجاح العملية
  bool get isSuccessful => isSuccess && errorMessage == null;

  @override
  String toString() {
    return 'ServerInfo(message: $message, endpoints: ${endpoints.length})';
  }
}
