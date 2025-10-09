import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/Services/API/api_services_disease.dart';
import '../../../home/presentation/pages/recommended_products_screen.dart';

class DiseaseDetectionScreen extends StatefulWidget {
  const DiseaseDetectionScreen({super.key});

  @override
  State<DiseaseDetectionScreen> createState() => _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> {
  final DiseaseDetectionApiService _apiService = DiseaseDetectionApiService();
  final ImagePicker _picker = ImagePicker();

  XFile? _selectedImage;
  DiseaseDetectionResult? _detectionResult;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('كشف سرطان الجلد'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // منطقة عرض الصورة
              Container(
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(_selectedImage!.path),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                    : const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'لم يتم اختيار صورة',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),

              const SizedBox(height: 16),

              // أزرار اختيار الصورة
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickImageFromGallery,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('من المعرض'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickImageFromCamera,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('من الكاميرا'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // زر التحليل
              ElevatedButton(
                onPressed: _selectedImage != null && !_isLoading
                    ? _analyzeImage
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('جاري التحليل...'),
                        ],
                      )
                    : const Text(
                        'تحليل الصورة',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),

              const SizedBox(height: 16),

              // عرض النتائج
              if (_detectionResult != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _detectionResult!.isSuccessful
                        ? Colors.green[50]
                        : Colors.red[50],
                    border: Border.all(
                      color: _detectionResult!.isSuccessful
                          ? Colors.green[300]!
                          : Colors.red[300]!,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _detectionResult!.isSuccessful
                                ? Icons.check_circle
                                : Icons.error,
                            color: _detectionResult!.isSuccessful
                                ? Colors.green[600]
                                : Colors.red[600],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _detectionResult!.isSuccessful
                                ? 'تم التحليل بنجاح'
                                : 'فشل في التحليل',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _detectionResult!.isSuccessful
                                  ? Colors.green[700]
                                  : Colors.red[700],
                            ),
                          ),
                        ],
                      ),
                      if (_detectionResult!.isSuccessful) ...[
                        const SizedBox(height: 8),
                        _buildResultRowWithCopy('Disease Type:',
                            _detectionResult!.diseaseNameEnglish),
                        _buildResultRowWithCopy(
                            'Technical Type:', _detectionResult!.diseaseType),
                        _buildResultRowWithCopy('Confidence Level:',
                            '${_detectionResult!.confidencePercentage}%'),
                        const SizedBox(height: 8),
                        Text(
                          'Description:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildDescriptionWithCopy(
                            _detectionResult!.diseaseDescriptionEnglish),
                        const SizedBox(height: 12),
                        // زر Gemini Chat
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _openGeminiChat(
                                _detectionResult!.diseaseNameEnglish),
                            icon: const Icon(Icons.chat, size: 20),
                            label:
                                const Text('Get AI Treatment Recommendations'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 8),
                        Text(
                          _detectionResult!.errorMessage ?? 'حدث خطأ غير معروف',
                          style: TextStyle(color: Colors.red[600]),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16), // مساحة إضافية في النهاية
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRowWithCopy(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                IconButton(
                  onPressed: () => _copyToClipboard(value),
                  icon: Icon(
                    Icons.copy,
                    size: 18,
                    color: Colors.blue[600],
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionWithCopy(String description) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => _copyToClipboard(description),
            icon: Icon(
              Icons.copy,
              size: 18,
              color: Colors.blue[600],
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
          _detectionResult = null; // إعادة تعيين النتائج
        });
      }
    } catch (e) {
      _showErrorSnackBar('خطأ في اختيار الصورة: $e');
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
          _detectionResult = null; // إعادة تعيين النتائج
        });
      }
    } catch (e) {
      _showErrorSnackBar('خطأ في التقاط الصورة: $e');
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _apiService.detectSkinDisease(
        imageFile: _selectedImage!,
      );

      setState(() {
        _detectionResult = result;
        _isLoading = false;
      });

      if (!result.isSuccessful) {
        _showErrorSnackBar(result.errorMessage ?? 'فشل في تحليل الصورة');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('حدث خطأ: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم نسخ النص'),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openGeminiChat(String diseaseName) {
    if (_selectedImage != null && _detectionResult != null) {
      // إنشاء صفحة الشات مباشرة مع session ID
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecommendedProductsScreen(
            imageFile: File(_selectedImage!.path),
          ),
        ),
      );
    } else {
      _showErrorSnackBar('يرجى تحليل الصورة أولاً');
    }
  }
}
