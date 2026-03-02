import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../app_colors.dart';
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('كشف سرطان الجلد'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image preview area
              Container(
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.lightPeach,
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: FutureBuilder<Uint8List>(
                          future: _selectedImage!.readAsBytes(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Image.memory(
                                snapshot.data!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              );
                            }

                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              size: 64,
                              color: AppColors.lavender,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'لم يتم اختيار صورة',
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),

              const SizedBox(height: 16),

              // Image selection buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickImageFromGallery,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('من المعرض'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mintTeal,
                        foregroundColor: AppColors.darkTeal,
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
                        backgroundColor: AppColors.lavender,
                        foregroundColor: AppColors.darkLavender,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Analyze button
              ElevatedButton(
                onPressed: _selectedImage != null && !_isLoading
                    ? _analyzeImage
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mauve,
                  foregroundColor: AppColors.darkMauve,
                  disabledBackgroundColor: AppColors.softPink.withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: AppColors.darkMauve,
                              strokeWidth: 2,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text('جاري التحليل...'),
                        ],
                      )
                    : const Text(
                        'تحليل الصورة',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),

              const SizedBox(height: 16),

              // Results display
              if (_detectionResult != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _detectionResult!.isSuccessful
                        ? AppColors.lightMint
                        : AppColors.softPink.withOpacity(0.5),
                    border: Border.all(
                      color: _detectionResult!.isSuccessful
                          ? AppColors.mintTeal
                          : AppColors.mauve,
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
                                ? AppColors.darkTeal
                                : AppColors.darkPink,
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
                                  ? AppColors.darkTeal
                                  : AppColors.darkPink,
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
                            color: AppColors.darkWarm,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildDescriptionWithCopy(
                            _detectionResult!.diseaseDescriptionEnglish),
                        const SizedBox(height: 12),
                        // Gemini Chat button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _openGeminiChat(
                                _detectionResult!.diseaseNameEnglish),
                            icon: const Icon(Icons.chat, size: 20),
                            label:
                                const Text('Get AI Treatment Recommendations'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mintTeal,
                              foregroundColor: AppColors.darkTeal,
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
                          style: TextStyle(color: AppColors.darkPink),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
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
                color: AppColors.darkWarm,
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
                    color: AppColors.mintTeal,
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
        color: AppColors.lightPeach,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.peach),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                color: AppColors.darkWarm,
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
              color: AppColors.mintTeal,
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
          _detectionResult = null;
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
          _detectionResult = null;
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
        backgroundColor: AppColors.darkPink,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم نسخ النص'),
        backgroundColor: AppColors.darkTeal,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openGeminiChat(String diseaseName) {
    if (_selectedImage != null && _detectionResult != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecommendedProductsScreen(
            imageFile: _selectedImage!,
          ),
        ),
      );
    } else {
      _showErrorSnackBar('يرجى تحليل الصورة أولاً');
    }
  }
}
