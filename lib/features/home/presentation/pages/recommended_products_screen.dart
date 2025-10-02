import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../constants.dart';

class RecommendedProductsScreen extends StatefulWidget {
  final File imageFile;

  const RecommendedProductsScreen({super.key, required this.imageFile});

  @override
  State<RecommendedProductsScreen> createState() =>
      _RecommendedProductsScreenState();
}

class _RecommendedProductsScreenState extends State<RecommendedProductsScreen> {
  bool isLoading = true;
  List<dynamic> products = [];
  String? detectedSkinType;
  String? detectedConcern;

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<List<dynamic>> uploadImageAndGetRecommendations(File imageFile) async {
    final uriPredict = Uri.parse('http://$ip:8000/predict');
    final uriRecommend = Uri.parse('http://$ip:8000/recommend');

    var request = http.MultipartRequest('POST', uriPredict);
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));
    var response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Failed to predict');
    }

    final responseBody = await response.stream.bytesToString();
    final prediction = jsonDecode(responseBody);
    final skinType = prediction['skin_type'];
    final concern = prediction['concern'];

    final recResponse = await http.post(
      uriRecommend,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'skin_type': skinType, 'concern': concern}),
    );

    if (recResponse.statusCode != 200) {
      throw Exception('Failed to get recommendations');
    }

    setState(() {
      detectedSkinType = skinType;
      detectedConcern = concern;
    });

    final recommendations = jsonDecode(recResponse.body)['recommendations'];
    return recommendations;
  }

  Future<void> _loadRecommendations() async {
    try {
      final result = await uploadImageAndGetRecommendations(widget.imageFile);
      setState(() {
        products = result;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildProductCard(
      Map product, TextTheme textTheme, ColorScheme colorScheme) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.background,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image/icon
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(Icons.spa_outlined,
                  size: 40, color: colorScheme.primary),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product['product_name'] ?? '',
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                product['product_type'] ?? '',
                style:
                    textTheme.labelMedium?.copyWith(color: colorScheme.primary),
              ),
              Text(
                "\$${product['price'].toString()}",
                style: textTheme.labelMedium
                    ?.copyWith(color: colorScheme.secondary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (product['concern_list'] != null)
            Wrap(
              spacing: 4,
              runSpacing: 2,
              children: List<Widget>.from(
                (product['concern_list'] as List).map((e) => Chip(
                      label: Text(e),
                      backgroundColor: colorScheme.primaryContainer,
                      visualDensity: VisualDensity.compact,
                      labelStyle: textTheme.labelSmall,
                    )),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Column(
        children: [
          // Image preview
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.file(widget.imageFile, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back,
                            color: colorScheme.onPrimary),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Rescan",
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                if (isLoading) const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),

          // Results area
          if (!isLoading)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              decoration: BoxDecoration(
                color: colorScheme.surface.withOpacity(0.95),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Skin type + concern
                  if (detectedSkinType != null || detectedConcern != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          if (detectedSkinType != null)
                            Chip(
                              label: Text("Skin: $detectedSkinType"),
                              backgroundColor: colorScheme.primaryContainer,
                              labelStyle: textTheme.labelSmall,
                            ),
                          const SizedBox(width: 8),
                          if (detectedConcern != null)
                            Chip(
                              label: Text("Concern: $detectedConcern"),
                              backgroundColor: colorScheme.secondaryContainer,
                              labelStyle: textTheme.labelSmall,
                            ),
                        ],
                      ),
                    ),

                  // Title
                  Text(
                    "Best Solution",
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Product list
                  SizedBox(
                    height: 160,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: products.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return _buildProductCard(
                            product, textTheme, colorScheme);
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
