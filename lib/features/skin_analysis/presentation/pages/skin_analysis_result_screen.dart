import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app_colors.dart';
import '../../../../core/Services/API/skin_care_api_service.dart';
import '../../../../core/localization/app_localizations.dart';

class SkinAnalysisResultScreen extends StatefulWidget {
  final XFile imageFile;

  const SkinAnalysisResultScreen({
    super.key,
    required this.imageFile,
  });

  @override
  State<SkinAnalysisResultScreen> createState() =>
      _SkinAnalysisResultScreenState();
}

class _SkinAnalysisResultScreenState extends State<SkinAnalysisResultScreen> {
  final SkinCareApiService _skinCareApiService = SkinCareApiService();

  bool _isAnalyzing = true;
  bool _isAnalysisComplete = false;
  CompleteAnalysisResult? _result;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _analyzeSkin();
  }

  Future<void> _analyzeSkin() async {
    try {
      final result = await _skinCareApiService.analyzeAndRecommend(
        imageFile: widget.imageFile,
      );

      if (result.isSuccessful) {
        setState(() {
          _result = result;
          _isAnalysisComplete = true;
          _isAnalyzing = false;
        });
      } else {
        setState(() {
          _errorMessage = result.errorMessage ?? 'Failed to analyze skin';
          _isAnalyzing = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isAnalyzing = false;
      });
    }
  }

  Future<void> _openProductUrl(String url) async {
    final loc = AppLocalizations.of(context);
    try {
      final uri = Uri.tryParse(url) ?? Uri.parse(url.replaceAll(' ', '%20'));

      await launchUrl(
        uri,
        mode: LaunchMode.platformDefault,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('${loc.translate('cannot_open_link')}: $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(loc.translate('skin_analysis')),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isAnalyzing) {
      return _buildLoadingState();
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_isAnalysisComplete && _result != null) {
      return _buildResultState();
    }

    final loc = AppLocalizations.of(context);
    return Center(child: Text(loc.translate('unknown_state')));
  }

  Widget _buildLoadingState() {
    final loc = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(AppColors.mintTeal),
            strokeWidth: 4,
          ),
          const SizedBox(height: 24),
          Text(
            loc.translate('analyzing_your_skin'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.darkTeal,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            loc.translate('wait_analyze_photo'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.darkLavender,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    final colorScheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              loc.translate('analysis_failed'),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? loc.translate('error_occurred'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: Text(loc.translate('try_again')),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.softPink,
                foregroundColor: AppColors.darkPink,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultState() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageSection(),
          _buildSuccessMessage(),
          const SizedBox(height: 5),
          _buildAnalysisResults(),
          const SizedBox(height: 5),
          _buildRecommendations(),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkWarm.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.darkWarm.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FutureBuilder<Uint8List>(
          future: widget.imageFile.readAsBytes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Image.memory(
                snapshot.data!,
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 350,
                    color: AppColors.lightMint,
                    child:
                        Icon(Icons.image, size: 80, color: AppColors.lavender),
                  );
                },
              );
            }

            return Container(
              width: double.infinity,
              height: 350,
              color: AppColors.lightMint,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: AppColors.mintTeal,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSuccessMessage() {
    final loc = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightMint,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.mintTeal, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkWarm.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.mintTeal,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.check_circle,
              color: AppColors.lightPeach,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.translate('analysis_complete'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.darkTeal,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  loc.translate('skin_analyzed_success'),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.darkTeal,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisResults() {
    if (_result == null) return const SizedBox.shrink();

    final loc = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.translate('analysis_results'),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),

          // Skin type card
          _buildInfoCard(
            icon: Icons.face,
            title: loc.translate('skin_type'),
            value: _result!.skinType,
            confidence: _result!.confidence.skinTypeConfidencePercentage,
            color: AppColors.mintTeal,
            darkColor: AppColors.darkTeal,
          ),

          const SizedBox(height: 12),

          // Concern card
          _buildInfoCard(
            icon: Icons.visibility,
            title: loc.translate('concern'),
            value: _result!.concern,
            confidence: _result!.confidence.concernConfidencePercentage,
            color: AppColors.mauve,
            darkColor: AppColors.darkMauve,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required String confidence,
    required Color color,
    required Color darkColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightPeach,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkWarm.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.lightPeach, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: darkColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkWarm,
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$confidence%',
              style: TextStyle(
                color: darkColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    if (_result == null || _result!.recommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    final loc = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                loc.translate('recommended_products'),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._result!.recommendations
              .map(
                (product) => _buildProductCard(product),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildProductCard(ProductRecommendation product) {
    final loc = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: AppColors.lightPeach,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _openProductUrl(product.productUrl),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.lightMint,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.shopping_bag,
                  color: AppColors.darkTeal,
                  size: 30,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.lightLavender,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColors.lavender,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            product.productType,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.darkLavender,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                    ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.softPink,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            product.price,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: AppColors.darkPink,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _openProductUrl(product.productUrl),
                icon: Icon(
                  Icons.open_in_new,
                  color: AppColors.darkTeal,
                ),
                tooltip: loc.translate('open_product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
