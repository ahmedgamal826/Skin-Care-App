import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

/// خدمة API للكشف عن سرطان الجلد
class DiseaseDetectionApiService {
  static const String baseUrl =
      "http://127.0.0.1:5000"; // URL الخاص بـ Flask API

  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      "Accept": "application/json",
      "Content-Type": "multipart/form-data",
    },
  ));

  /// إرسال صورة للكشف عن نوع سرطان الجلد
  Future<DiseaseDetectionResult> detectSkinDisease({
    required XFile imageFile,
  }) async {
    try {
      // تحويل XFile إلى File
      final file = File(imageFile.path);

      // إنشاء FormData للصورة
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          file.path,
          filename: imageFile.name,
        ),
      });

      // إرسال الطلب إلى API
      final response = await _dio.post(
        '/predict',
        data: formData,
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // استخراج البيانات من الاستجابة
        final prediction = data['class'] as String? ?? 'unknown';
        final confidence = (data['confidence'] as num?)?.toDouble() ?? 0.0;

        return DiseaseDetectionResult(
          diseaseType: prediction,
          confidence: confidence,
          confidencePercentage: (confidence * 100).toStringAsFixed(2),
          isSuccess: true,
          errorMessage: null,
        );
      } else {
        return DiseaseDetectionResult(
          diseaseType: 'unknown',
          confidence: 0.0,
          confidencePercentage: '0.00',
          isSuccess: false,
          errorMessage:
              'فشل في تحليل الصورة. رمز الخطأ: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'حدث خطأ في الاتصال بالخادم';

      if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'انتهت مهلة الاتصال. تأكد من تشغيل الخادم';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'انتهت مهلة استقبال البيانات';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage =
            'خطأ في الاتصال. تأكد من تشغيل Flask API على المنفذ 5000';
      } else if (e.response?.statusCode != null) {
        errorMessage = 'خطأ من الخادم: ${e.response?.statusCode}';
      }

      return DiseaseDetectionResult(
        diseaseType: 'unknown',
        confidence: 0.0,
        confidencePercentage: '0.00',
        isSuccess: false,
        errorMessage: errorMessage,
      );
    } catch (e) {
      return DiseaseDetectionResult(
        diseaseType: 'unknown',
        confidence: 0.0,
        confidencePercentage: '0.00',
        isSuccess: false,
        errorMessage: 'حدث خطأ غير متوقع: ${e.toString()}',
      );
    }
  }

  /// الحصول على وصف مفصل لنوع المرض بالإنجليزية
  String getDiseaseDescriptionEnglish(String diseaseType) {
    switch (diseaseType.toLowerCase()) {
      case 'nv':
        return 'Nevus - A benign growth on the skin, commonly known as a mole';
      case 'mel':
        return 'Melanoma - A serious type of skin cancer that can be life-threatening if not treated early';
      case 'bkl':
        return 'Benign Keratosis-like lesions - Non-cancerous skin growths that resemble keratosis';
      case 'bcc':
        return 'Basal Cell Carcinoma - The most common type of skin cancer, usually slow-growing';
      case 'akiec':
        return 'Actinic Keratosis - Pre-cancerous skin lesions caused by sun damage';
      case 'vasc':
        return 'Vascular lesion - Abnormal growth of blood vessels in the skin';
      case 'df':
        return 'Dermatofibroma - A benign skin tumor that feels like a hard lump';
      default:
        return 'Unknown type of skin lesion';
    }
  }

  /// الحصول على اسم المرض بالإنجليزية
  String getDiseaseNameEnglish(String diseaseType) {
    switch (diseaseType.toLowerCase()) {
      case 'nv':
        return 'Nevus (Mole)';
      case 'mel':
        return 'Melanoma';
      case 'bkl':
        return 'Benign Keratosis-like lesions';
      case 'bcc':
        return 'Basal Cell Carcinoma';
      case 'akiec':
        return 'Actinic Keratosis';
      case 'vasc':
        return 'Vascular lesion';
      case 'df':
        return 'Dermatofibroma';
      default:
        return 'Unknown';
    }
  }

  /// الحصول على وصف مفصل لنوع المرض
  String getDiseaseDescription(String diseaseType) {
    switch (diseaseType.toLowerCase()) {
      case 'nv':
        return 'شامة حميدة (Nevus) - نمو حميد في الجلد';
      case 'mel':
        return 'سرطان الجلد الميلانيني (Melanoma) - نوع خطير من سرطان الجلد';
      case 'bkl':
        return 'آفات شبيهة بالتقرن الحميد (Benign Keratosis-like lesions)';
      case 'bcc':
        return 'سرطان الخلايا القاعدية (Basal Cell Carcinoma) - نوع شائع من سرطان الجلد';
      case 'akiec':
        return 'التقرن الشعاعي (Actinic Keratosis) - آفة ما قبل سرطانية';
      case 'vasc':
        return 'آفة وعائية (Vascular lesion) - مشكلة في الأوعية الدموية';
      case 'df':
        return 'ورم ليفي جلدي (Dermatofibroma) - ورم حميد في الجلد';
      default:
        return 'نوع غير معروف من الآفات الجلدية';
    }
  }

  /// الحصول على نص عربي لنوع المرض
  String getDiseaseNameArabic(String diseaseType) {
    switch (diseaseType.toLowerCase()) {
      case 'nv':
        return 'شامة حميدة';
      case 'mel':
        return 'سرطان الجلد الميلانيني';
      case 'bkl':
        return 'آفات شبيهة بالتقرن الحميد';
      case 'bcc':
        return 'سرطان الخلايا القاعدية';
      case 'akiec':
        return 'التقرن الشعاعي';
      case 'vasc':
        return 'آفة وعائية';
      case 'df':
        return 'ورم ليفي جلدي';
      default:
        return 'غير معروف';
    }
  }

  /// التحقق من حالة الخادم
  Future<bool> checkServerStatus() async {
    try {
      final response = await _dio.get('/');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

/// نموذج بيانات لنتيجة الكشف عن المرض
class DiseaseDetectionResult {
  final String diseaseType;
  final double confidence;
  final String confidencePercentage;
  final bool isSuccess;
  final String? errorMessage;

  DiseaseDetectionResult({
    required this.diseaseType,
    required this.confidence,
    required this.confidencePercentage,
    required this.isSuccess,
    this.errorMessage,
  });

  /// الحصول على اسم المرض بالعربية
  String get diseaseNameArabic {
    final service = DiseaseDetectionApiService();
    return service.getDiseaseNameArabic(diseaseType);
  }

  /// الحصول على اسم المرض بالإنجليزية
  String get diseaseNameEnglish {
    final service = DiseaseDetectionApiService();
    return service.getDiseaseNameEnglish(diseaseType);
  }

  /// الحصول على وصف المرض
  String get diseaseDescription {
    final service = DiseaseDetectionApiService();
    return service.getDiseaseDescription(diseaseType);
  }

  /// الحصول على وصف المرض بالإنجليزية
  String get diseaseDescriptionEnglish {
    final service = DiseaseDetectionApiService();
    return service.getDiseaseDescriptionEnglish(diseaseType);
  }

  /// التحقق من نجاح العملية
  bool get isSuccessful => isSuccess && errorMessage == null;

  @override
  String toString() {
    return 'DiseaseDetectionResult(diseaseType: $diseaseType, confidence: $confidence, isSuccess: $isSuccess)';
  }
}
