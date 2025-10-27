# خدمة تحليل البشرة والتوصيات - Skin Care API Service

## نظرة عامة
تم إنشاء خدمة شاملة لدمج Flask API الخاص بتحليل البشرة والتوصيات مع تطبيق Flutter. هذه الخدمة تدعم جميع endpoints المطلوبة وتوفر واجهة سهلة الاستخدام.

## الملفات المضافة

### 1. `lib/core/Services/API/skin_care_api_service.dart`
الخدمة الرئيسية التي تحتوي على:
- `SkinCareApiService` - الكلاس الرئيسي للخدمة
- نماذج البيانات المختلفة للاستجابة من API
- معالجة الأخطاء الشاملة
- دعم جميع endpoints

### 2. `lib/features/skin_analysis_example.dart`
مثال شامل لكيفية استخدام الخدمة في التطبيق

## الميزات المتاحة

### 1. التحقق من حالة الخادم
```dart
final isConnected = await _apiService.checkServerStatus();
```

### 2. تحليل البشرة فقط
```dart
final result = await _apiService.analyzeSkin(imageFile: imageFile);
```

### 3. الحصول على التوصيات
```dart
final result = await _apiService.getRecommendations(
  skinType: 'Normal',
  concern: 'Acne',
);
```

### 4. التحليل والتوصيات في طلب واحد
```dart
final result = await _apiService.analyzeAndRecommend(imageFile: imageFile);
```

### 5. الحصول على معلومات الخادم
```dart
final info = await _apiService.getServerInfo();
```

## نماذج البيانات

### SkinAnalysisResult
```dart
class SkinAnalysisResult {
  final String skinType;           // نوع البشرة
  final String concern;            // الاهتمام
  final ConfidenceData confidence; // بيانات الثقة
  final bool isSuccess;            // نجاح العملية
  final String? errorMessage;       // رسالة الخطأ
}
```

### ProductRecommendation
```dart
class ProductRecommendation {
  final String productName;  // اسم المنتج
  final String productUrl;   // رابط المنتج
  final String productType;  // نوع المنتج
  final String price;        // السعر
}
```

### CompleteAnalysisResult
```dart
class CompleteAnalysisResult {
  final String skinType;                           // نوع البشرة
  final String concern;                            // الاهتمام
  final ConfidenceData confidence;                 // بيانات الثقة
  final List<ProductRecommendation> recommendations; // التوصيات
  final bool isSuccess;                            // نجاح العملية
  final String? errorMessage;                       // رسالة الخطأ
}
```

## كيفية الاستخدام

### 1. إضافة الاستيراد
```dart
import '../core/Services/API/skin_care_api_service.dart';
```

### 2. إنشاء مثيل من الخدمة
```dart
final SkinCareApiService apiService = SkinCareApiService();
```

### 3. التحقق من الاتصال
```dart
final isConnected = await apiService.checkServerStatus();
if (isConnected) {
  // الخادم متصل، يمكن المتابعة
} else {
  // الخادم غير متصل، عرض رسالة خطأ
}
```

### 4. تحليل صورة
```dart
// التقاط صورة
final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);

if (image != null) {
  // تحليل البشرة
  final result = await apiService.analyzeSkin(imageFile: image);
  
  if (result.isSuccessful) {
    print('نوع البشرة: ${result.skinTypeArabic}');
    print('الاهتمام: ${result.concernArabic}');
    print('ثقة النتيجة: ${result.confidence.skinTypeConfidencePercentage}%');
  } else {
    print('خطأ: ${result.errorMessage}');
  }
}
```

### 5. الحصول على التوصيات
```dart
final recommendations = await apiService.getRecommendations(
  skinType: 'Normal',
  concern: 'Acne',
);

if (recommendations.isSuccessful) {
  for (var product in recommendations.recommendations) {
    print('المنتج: ${product.productName}');
    print('النوع: ${product.productTypeArabic}');
    print('السعر: ${product.price}');
    print('الرابط: ${product.productUrl}');
  }
}
```

### 6. التحليل والتوصيات الكامل
```dart
final completeResult = await apiService.analyzeAndRecommend(imageFile: image);

if (completeResult.isSuccessful) {
  // عرض نتائج التحليل
  print('نوع البشرة: ${completeResult.skinType}');
  print('الاهتمام: ${completeResult.concern}');
  
  // عرض التوصيات
  for (var product in completeResult.recommendations) {
    print('المنتج: ${product.productName}');
  }
}
```

## معالجة الأخطاء

الخدمة تدعم معالجة شاملة للأخطاء:

```dart
try {
  final result = await apiService.analyzeSkin(imageFile: image);
  
  if (result.isSuccessful) {
    // نجح التحليل
  } else {
    // فشل التحليل، عرض رسالة الخطأ
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('خطأ'),
        content: Text(result.errorMessage ?? 'حدث خطأ غير متوقع'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('موافق'),
          ),
        ],
      ),
    );
  }
} catch (e) {
  // خطأ في الاتصال أو معالجة البيانات
  print('خطأ: $e');
}
```

## الترجمة العربية

الخدمة تدعم الترجمة العربية التلقائية:

- **أنواع البشرة:**
  - Oily → دهنية
  - Dry → جافة
  - Normal → عادية

- **الاهتمامات:**
  - Acne → حب الشباب
  - Bags → الهالات السوداء
  - Enlarged pores → المسام الواسعة
  - Redness → الاحمرار

- **أنواع المنتجات:**
  - Exfoliator → مقشر
  - Balm → مرهم
  - Bath Oil → زيت حمام
  - Body Wash → غسول الجسم
  - Cleanser → منظف
  - Moisturizer → مرطب
  - Serum → سيروم
  - Toner → تونر
  - Mask → قناع
  - Sunscreen → واقي شمس

## متطلبات النظام

1. **Flask API** يجب أن يكون يعمل على `http://127.0.0.1:5000`
2. **Dependencies** المطلوبة موجودة بالفعل في `pubspec.yaml`:
   - `dio: ^5.9.0`
   - `image_picker: ^1.1.2`
   - `url_launcher: ^6.2.2`

## نصائح للاستخدام

1. **تحقق من الاتصال:** دائماً تحقق من حالة الخادم قبل إرسال الطلبات
2. **معالجة الأخطاء:** استخدم try-catch وفحص `isSuccessful` للتعامل مع الأخطاء
3. **تحسين الصور:** استخدم `maxWidth` و `maxHeight` لتحسين جودة الصور
4. **عرض التحميل:** استخدم مؤشر التحميل أثناء انتظار الاستجابة
5. **فتح الروابط:** استخدم `url_launcher` لفتح روابط المنتجات

## مثال كامل

راجع ملف `lib/features/skin_analysis_example.dart` للحصول على مثال كامل وشامل لكيفية استخدام الخدمة في تطبيق Flutter حقيقي.

---

**ملاحظة:** تأكد من تشغيل Flask API على المنفذ 5000 قبل استخدام الخدمة في التطبيق.
