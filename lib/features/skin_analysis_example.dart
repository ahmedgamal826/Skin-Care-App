import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/Services/API/skin_care_api_service.dart';
import '../app_colors.dart';

/// Example of how to use SkinCareApiService in the app
class SkinCareAnalysisExample extends StatefulWidget {
  const SkinCareAnalysisExample({super.key});

  @override
  State<SkinCareAnalysisExample> createState() =>
      _SkinCareAnalysisExampleState();
}

class _SkinCareAnalysisExampleState extends State<SkinCareAnalysisExample> {
  final SkinCareApiService _apiService = SkinCareApiService();
  final ImagePicker _imagePicker = ImagePicker();

  bool _isLoading = false;
  bool _serverConnected = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkServerStatus();
  }

  /// Check server status
  Future<void> _checkServerStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final isConnected = await _apiService.checkServerStatus();
      setState(() {
        _serverConnected = isConnected;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _serverConnected = false;
        _isLoading = false;
        _errorMessage = 'خطأ في الاتصال بالخادم: $e';
      });
    }
  }

  /// Take photo from camera
  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        await _analyzeSkin(image);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error taking photo: $e';
      });
    }
  }

  /// Choose photo from gallery
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        await _analyzeSkin(image);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error choosing photo: $e';
      });
    }
  }

  /// Analyze skin only
  Future<void> _analyzeSkin(XFile imageFile) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _apiService.analyzeSkin(imageFile: imageFile);

      setState(() {
        _isLoading = false;
      });

      if (result.isSuccessful) {
        // عرض النتائج
        _showAnalysisResults(result);
      } else {
        setState(() {
          _errorMessage = result.errorMessage ?? 'فشل في تحليل البشرة';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'خطأ في تحليل البشرة: $e';
      });
    }
  }

  /// الحصول على التوصيات بناءً على نوع البشرة والاهتمام
  Future<void> _getRecommendations(String skinType, String concern) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _apiService.getRecommendations(
        skinType: skinType,
        concern: concern,
      );

      setState(() {
        _isLoading = false;
      });

      if (result.isSuccessful) {
        _showRecommendations(result);
      } else {
        setState(() {
          _errorMessage = result.errorMessage ?? 'فشل في الحصول على التوصيات';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'خطأ في الحصول على التوصيات: $e';
      });
    }
  }

  /// تحليل البشرة والحصول على التوصيات في طلب واحد
  Future<void> _analyzeAndRecommend(XFile imageFile) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result =
          await _apiService.analyzeAndRecommend(imageFile: imageFile);

      setState(() {
        _isLoading = false;
      });

      if (result.isSuccessful) {
        _showCompleteResults(result);
      } else {
        setState(() {
          _errorMessage = result.errorMessage ?? 'فشل في التحليل والتوصيات';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'خطأ في التحليل والتوصيات: $e';
      });
    }
  }

  /// عرض نتائج التحليل
  void _showAnalysisResults(SkinAnalysisResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('نتائج تحليل البشرة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('نوع البشرة: ${result.skinTypeArabic}'),
            Text('الاهتمام: ${result.concernArabic}'),
            const SizedBox(height: 8),
            Text(
                'ثقة نوع البشرة: ${result.confidence.skinTypeConfidencePercentage}%'),
            Text(
                'ثقة الاهتمام: ${result.confidence.concernConfidencePercentage}%'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _getRecommendations(result.skinType, result.concern);
            },
            child: const Text('احصل على التوصيات'),
          ),
        ],
      ),
    );
  }

  /// عرض التوصيات
  void _showRecommendations(ProductRecommendationResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('التوصيات'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: result.recommendations.length,
            itemBuilder: (context, index) {
              final product = result.recommendations[index];
              return Card(
                child: ListTile(
                  title: Text(product.productName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('النوع: ${product.productTypeArabic}'),
                      Text('السعر: ${product.price}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.open_in_new),
                    onPressed: () => _openProductUrl(product.productUrl),
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  /// عرض النتائج الكاملة
  void _showCompleteResults(CompleteAnalysisResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('التحليل والتوصيات'),
        content: SizedBox(
          width: double.maxFinite,
          height: 500,
          child: Column(
            children: [
              // معلومات التحليل
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('نوع البشرة: ${result.skinType}'),
                      Text('الاهتمام: ${result.concern}'),
                      Text(
                          'ثقة نوع البشرة: ${result.confidence.skinTypeConfidencePercentage}%'),
                      Text(
                          'ثقة الاهتمام: ${result.confidence.concernConfidencePercentage}%'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // التوصيات
              Expanded(
                child: ListView.builder(
                  itemCount: result.recommendations.length,
                  itemBuilder: (context, index) {
                    final product = result.recommendations[index];
                    return Card(
                      child: ListTile(
                        title: Text(product.productName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('النوع: ${product.productTypeArabic}'),
                            Text('السعر: ${product.price}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.open_in_new),
                          onPressed: () => _openProductUrl(product.productUrl),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  /// فتح رابط المنتج
  Future<void> _openProductUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        setState(() {
          _errorMessage = 'لا يمكن فتح الرابط: $url';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'خطأ في فتح الرابط: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحليل البشرة والتوصيات'),
        backgroundColor: AppColors.mintTeal,
        foregroundColor: AppColors.darkTeal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // حالة الخادم
            Card(
              color: _serverConnected
                  ? AppColors.lightMint
                  : AppColors.softPink,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      _serverConnected ? Icons.check_circle : Icons.error,
                      color: _serverConnected
                          ? AppColors.mintTeal
                          : AppColors.mauve,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _serverConnected ? 'الخادم متصل' : 'الخادم غير متصل',
                      style: TextStyle(
                        color: _serverConnected
                            ? AppColors.darkTeal
                            : AppColors.darkPink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _checkServerStatus,
                      child: const Text('إعادة فحص'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // رسالة الخطأ
            if (_errorMessage != null)
              Card(
                color: AppColors.softPink,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: AppColors.darkPink),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // أزرار التحليل
            ElevatedButton.icon(
              onPressed:
                  _serverConnected && !_isLoading ? _pickImageFromCamera : null,
              icon: const Icon(Icons.camera_alt),
              label: const Text('التقاط صورة من الكاميرا'),
            ),

            const SizedBox(height: 8),

            ElevatedButton.icon(
              onPressed: _serverConnected && !_isLoading
                  ? _pickImageFromGallery
                  : null,
              icon: const Icon(Icons.photo_library),
              label: const Text('اختيار صورة من المعرض'),
            ),

            const SizedBox(height: 16),

            // زر التحليل والتوصيات الكامل
            ElevatedButton.icon(
              onPressed: _serverConnected && !_isLoading
                  ? () async {
                      final XFile? image = await _imagePicker.pickImage(
                        source: ImageSource.gallery,
                        maxWidth: 1024,
                        maxHeight: 1024,
                        imageQuality: 85,
                      );
                      if (image != null) {
                        await _analyzeAndRecommend(image);
                      }
                    }
                  : null,
              icon: const Icon(Icons.analytics),
              label: const Text('تحليل كامل مع التوصيات'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mauve,
                foregroundColor: AppColors.darkMauve,
              ),
            ),

            const SizedBox(height: 16),

            // مؤشر التحميل
            if (_isLoading)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    Text('جاري التحليل...'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
