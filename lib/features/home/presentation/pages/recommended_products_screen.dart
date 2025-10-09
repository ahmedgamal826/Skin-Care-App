// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import '../../../../constants.dart';

// class RecommendedProductsScreen extends StatefulWidget {
//   final File imageFile;

//   const RecommendedProductsScreen({super.key, required this.imageFile});

//   @override
//   State<RecommendedProductsScreen> createState() =>
//       _RecommendedProductsScreenState();
// }

// class _RecommendedProductsScreenState extends State<RecommendedProductsScreen> {
//   bool isLoading = true;
//   List<dynamic> products = [];
//   String? detectedSkinType;
//   String? detectedConcern;

//   @override
//   void initState() {
//     super.initState();
//     _loadRecommendations();
//   }

//   Future<List<dynamic>> uploadImageAndGetRecommendations(File imageFile) async {
//     final uriPredict = Uri.parse('http://$ip:8000/predict');
//     final uriRecommend = Uri.parse('http://$ip:8000/recommend');

//     var request = http.MultipartRequest('POST', uriPredict);
//     request.files
//         .add(await http.MultipartFile.fromPath('image', imageFile.path));
//     var response = await request.send();

//     if (response.statusCode != 200) {
//       throw Exception('Failed to predict');
//     }

//     final responseBody = await response.stream.bytesToString();
//     final prediction = jsonDecode(responseBody);
//     final skinType = prediction['skin_type'];
//     final concern = prediction['concern'];

//     final recResponse = await http.post(
//       uriRecommend,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'skin_type': skinType, 'concern': concern}),
//     );

//     if (recResponse.statusCode != 200) {
//       throw Exception('Failed to get recommendations');
//     }

//     setState(() {
//       detectedSkinType = skinType;
//       detectedConcern = concern;
//     });

//     final recommendations = jsonDecode(recResponse.body)['recommendations'];
//     return recommendations;
//   }

//   Future<void> _loadRecommendations() async {
//     try {
//       final result = await uploadImageAndGetRecommendations(widget.imageFile);
//       setState(() {
//         products = result;
//         isLoading = false;
//       });
//     } catch (e) {
//       print(e);
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Widget _buildProductCard(
//       Map product, TextTheme textTheme, ColorScheme colorScheme) {
//     return Container(
//       width: 220,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: colorScheme.background,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 6,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Product image/icon
//           Container(
//             height: 80,
//             decoration: BoxDecoration(
//               color: colorScheme.surfaceVariant,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Center(
//               child: Icon(Icons.spa_outlined,
//                   size: 40, color: colorScheme.primary),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             product['product_name'] ?? '',
//             style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 product['product_type'] ?? '',
//                 style:
//                     textTheme.labelMedium?.copyWith(color: colorScheme.primary),
//               ),
//               Text(
//                 "\$${product['price'].toString()}",
//                 style: textTheme.labelMedium
//                     ?.copyWith(color: colorScheme.secondary),
//               ),
//             ],
//           ),
//           const SizedBox(height: 6),
//           if (product['concern_list'] != null)
//             Wrap(
//               spacing: 4,
//               runSpacing: 2,
//               children: List<Widget>.from(
//                 (product['concern_list'] as List).map((e) => Chip(
//                       label: Text(e),
//                       backgroundColor: colorScheme.primaryContainer,
//                       visualDensity: VisualDensity.compact,
//                       labelStyle: textTheme.labelSmall,
//                     )),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;

//     return Scaffold(
//       body: Column(
//         children: [
//           // Image preview
//           Expanded(
//             child: Stack(
//               children: [
//                 Positioned.fill(
//                   child: Image.file(widget.imageFile, fit: BoxFit.cover),
//                 ),
//                 Positioned(
//                   top: 40,
//                   left: 16,
//                   right: 16,
//                   child: Row(
//                     children: [
//                       IconButton(
//                         onPressed: () => Navigator.pop(context),
//                         icon: Icon(Icons.arrow_back,
//                             color: colorScheme.onPrimary),
//                       ),
//                       Expanded(
//                         child: Center(
//                           child: Text(
//                             "Rescan",
//                             style: textTheme.titleMedium?.copyWith(
//                               color: colorScheme.onPrimary,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 48),
//                     ],
//                   ),
//                 ),
//                 if (isLoading) const Center(child: CircularProgressIndicator()),
//               ],
//             ),
//           ),

//           // Results area
//           if (!isLoading)
//             Container(
//               padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
//               decoration: BoxDecoration(
//                 color: colorScheme.surface.withOpacity(0.95),
//                 borderRadius:
//                     const BorderRadius.vertical(top: Radius.circular(24)),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Skin type + concern
//                   if (detectedSkinType != null || detectedConcern != null)
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 8.0),
//                       child: Row(
//                         children: [
//                           if (detectedSkinType != null)
//                             Chip(
//                               label: Text("Skin: $detectedSkinType"),
//                               backgroundColor: colorScheme.primaryContainer,
//                               labelStyle: textTheme.labelSmall,
//                             ),
//                           const SizedBox(width: 8),
//                           if (detectedConcern != null)
//                             Chip(
//                               label: Text("Concern: $detectedConcern"),
//                               backgroundColor: colorScheme.secondaryContainer,
//                               labelStyle: textTheme.labelSmall,
//                             ),
//                         ],
//                       ),
//                     ),

//                   // Title
//                   Text(
//                     "Best Solution",
//                     style: textTheme.titleMedium?.copyWith(
//                       fontWeight: FontWeight.w600,
//                       color: colorScheme.onSurface,
//                     ),
//                   ),
//                   const SizedBox(height: 12),

//                   // Product list
//                   SizedBox(
//                     height: 160,
//                     child: ListView.separated(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: products.length,
//                       separatorBuilder: (_, __) => const SizedBox(width: 12),
//                       itemBuilder: (context, index) {
//                         final product = products[index];
//                         return _buildProductCard(
//                             product, textTheme, colorScheme);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// lib/skin_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/Services/API/api_services_disease.dart';
import '../../../../core/Services/API/api_service.dart';

class RecommendedProductsScreen extends StatefulWidget {
  final File imageFile;
  const RecommendedProductsScreen({super.key, required this.imageFile});

  @override
  State<RecommendedProductsScreen> createState() =>
      _RecommendedProductsScreenState();
}

class _RecommendedProductsScreenState extends State<RecommendedProductsScreen>
    with TickerProviderStateMixin {
  final _followCtrl = TextEditingController();
  final _scroll = ScrollController();
  final DiseaseDetectionApiService _diseaseApiService =
      DiseaseDetectionApiService();
  final SkinApiClient _skinApiClient = SkinApiClient();

  late File _image;
  String? _sessionId;
  bool _loading = false;
  final List<_Bubble> _messages = [];
  TextDirection _followTextDirection = TextDirection.ltr;
  bool _isOnline = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _image = widget.imageFile;

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _fadeController.forward();
    _slideController.forward();
    _checkConnectionStatus();
  }

  Future<void> _analyze() async {
    setState(() => _loading = true);
    try {
      // أولاً: تحليل الصورة باستخدام DiseaseDetectionApiService للحصول على معلومات المرض
      final xFile = XFile(_image.path);
      final diseaseResult =
          await _diseaseApiService.detectSkinDisease(imageFile: xFile);

      // تم تحليل المرض بنجاح

      // استخدام session ID من API أو إنشاء واحد جديد
      _sessionId = DateTime.now().millisecondsSinceEpoch.toString();

      // لا توجد رسالة مستخدم في هذا الوضع

      // إنشاء رسالة AI بناءً على نتائج تحليل المرض
      String aiResponse = _createDiseaseResponse(diseaseResult);
      _messages.add(_Bubble(isUser: false, text: aiResponse));

      setState(() {
        _isOnline = true;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isOnline = false;
      });
      _snack("فشل في التحليل: ${e.toString()}");
    } finally {
      setState(() => _loading = false);
    }
  }

  String _createDiseaseResponse(DiseaseDetectionResult diseaseResult) {
    if (diseaseResult.isSuccessful) {
      return "Based on the analysis of your skin image, I can provide you with detailed recommendations for your skin condition.\n\n**Disease Name:** ${diseaseResult.diseaseNameEnglish}\n\n**Confidence Level:** ${diseaseResult.confidencePercentage}%";
    } else {
      return "Based on the analysis of your skin image, I can provide you with detailed recommendations for your skin condition.\n\n**Disease Name:** Analysis Failed\n\n**Confidence Level:** N/A";
    }
  }

  Future<void> _sendFollowUp() async {
    if (_sessionId == null || _followCtrl.text.trim().isEmpty) return;
    final q = _followCtrl.text.trim();
    _followCtrl.clear();
    _messages.add(_Bubble(isUser: true, text: q));
    setState(() => _loading = true);
    _scrollToBottom();

    try {
      // استخدام SkinApiClient للـ follow-up مع Gemini
      final aiReply = await _skinApiClient.followUp(
        sessionId: _sessionId!,
        message: q,
      );

      _messages.add(_Bubble(isUser: false, text: aiReply));
      setState(() {
        _isOnline = true;
      });
      _scrollToBottom();
    } catch (e) {
      // في حالة فشل Gemini، إظهار رسالة خطأ مع الاحتفاظ برسالة المستخدم
      setState(() {
        _isOnline = false;
      });

      String errorMessage = e.toString();
      if (errorMessage.contains('Session expired')) {
        // إعادة تحليل الصورة تلقائياً بدون رسالة
        await _reanalyzeAndRespond(q);
      } else {
        _snack("خطأ في الاتصال: $errorMessage");
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  /// إعادة تحليل الصورة والرد على الرسالة
  Future<void> _reanalyzeAndRespond(String message) async {
    try {
      setState(() => _loading = true);

      // إعادة تحليل الصورة باستخدام SkinApiClient للحصول على session_id صحيح
      final analysisResult = await _skinApiClient.analyze(
        imageFile: File(_image.path),
        message: message,
      );

      // استخدام session_id من الـ API
      _sessionId = analysisResult.sessionId;

      // لا نحتاج لإضافة رسالة المستخدم مرة أخرى لأنها موجودة بالفعل
      // إضافة رد الـ API فقط
      _messages.add(_Bubble(isUser: false, text: analysisResult.response));

      setState(() {
        _isOnline = true;
      });
      _scrollToBottom();

      // تم إعادة التحليل بنجاح بدون رسالة
    } catch (e) {
      _snack("فشل في إعادة التحليل: ${e.toString()}");
    } finally {
      setState(() => _loading = false);
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 250), () {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// تنظيف النص وإزالة النجوم وتحسين المظهر
  String _cleanText(String text) {
    // إزالة النجوم من النص
    String cleanedText = text.replaceAll('**', '');

    // تحسين المسافات ولكن الحفاظ على الأسطر الجديدة
    cleanedText = cleanedText.replaceAll(RegExp(r'[ \t]+'), ' ').trim();

    // إضافة مسافات بعد النقطتين
    cleanedText = cleanedText.replaceAll(':', ': ');

    return cleanedText;
  }

  Future<void> _checkConnectionStatus() async {
    // التحقق من حالة الخادم باستخدام SkinApiClient (المنفذ 5001)
    try {
      final isServerOnline = await _skinApiClient.checkServerStatus();
      if (mounted) {
        setState(() {
          _isOnline = isServerOnline;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isOnline = false;
        });
      }
    }
  }

  String _getErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('connection') ||
        errorString.contains('network') ||
        errorString.contains('unreachable') ||
        errorString.contains('timeout')) {
      return "🌐 No server connection. Please check your internet connection and try again.";
    } else if (errorString.contains('dioexception') ||
        errorString.contains('httpException')) {
      return "🔌 Server is not responding. Please ensure the server is running and try again.";
    } else if (errorString.contains('socket') ||
        errorString.contains('refused')) {
      return "⚠️ Unable to connect to server. Please check server status and network connection.";
    } else {
      return "❌ Analysis failed. Please try again later.";
    }
  }

  void _snack(String m) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(m),
          backgroundColor: Colors.red.shade600,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0E8E6),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Skin Care Analyzer',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child:
                  _sessionId == null ? _buildAnalyzeStage() : _buildChatStage(),
            ),
          ),
        ),
      ),
    );
  }

  // Stage 1: preview + note + start
  Widget _buildAnalyzeStage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Skin Care Analyzer",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _isOnline
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _isOnline ? "Online" : "Offline",
                  style: TextStyle(
                    color: _isOnline
                        ? Theme.of(context).colorScheme.onPrimary
                        : Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          // Image preview with enhanced styling
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  Image.file(
                    _image,
                    height: 280,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  // Positioned(
                  //   top: 12,
                  //   right: 12,
                  //   child: Container(
                  //     padding: const EdgeInsets.all(8),
                  //     decoration: BoxDecoration(
                  //       color: Colors.black.withOpacity(0.5),
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     child: const Icon(
                  //       Icons.visibility,
                  //       color: Colors.white,
                  //       size: 20,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Enhanced analyze button
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _loading ? null : _analyze,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_loading)
                        const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.analytics_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      const SizedBox(width: 12),
                      Text(
                        _loading ? "Analyzing..." : "Start Analysis",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Stage 2: chat view
  Widget _buildChatStage() {
    return Column(
      children: [
        // Chat header
        Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.psychology_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "Skin Care Analyzer",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _isOnline
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _isOnline ? "Online" : "Offline",
                  style: TextStyle(
                    color: _isOnline
                        ? Theme.of(context).colorScheme.onPrimary
                        : Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Messages area
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.05),
                ],
              ),
            ),
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final m = _messages[i];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: m.isUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: m.isUser
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (m.isUser) ...[
                            const SizedBox(width: 40),
                          ],
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: m.isUser ? 20 : 20,
                                vertical: 12,
                              ),
                              constraints: BoxConstraints(
                                maxWidth: m.isUser ? 250 : 320,
                              ),
                              decoration: BoxDecoration(
                                color: m.isUser
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.white.withOpacity(0.95),
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(20),
                                  topRight: const Radius.circular(20),
                                  bottomLeft: m.isUser
                                      ? const Radius.circular(20)
                                      : const Radius.circular(4),
                                  bottomRight: m.isUser
                                      ? const Radius.circular(4)
                                      : const Radius.circular(20),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: m.isUser ? 0 : 8,
                                  right: m.isUser ? 8 : 0,
                                ),
                                child: SelectableText(
                                  _cleanText(m.text),
                                  style: TextStyle(
                                    color: m.isUser
                                        ? Colors.white
                                        : Colors.black87,
                                    height: 1.5,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: m.isUser
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (!m.isUser) ...[
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.smart_toy_outlined,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ],
                          if (m.isUser) ...[
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.person_outline,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),

        // Loading indicator
        if (_loading)
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Typing...",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

        // Input area
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            border: Border(
              top: BorderSide(
                color: Colors.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _followCtrl,
                    textDirection: _followTextDirection,
                    textAlign: _followTextDirection == TextDirection.rtl
                        ? TextAlign.right
                        : TextAlign.left,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        final isArabic =
                            RegExp(r'[\u0600-\u06FF]').hasMatch(value);
                        setState(() {
                          _followTextDirection =
                              isArabic ? TextDirection.rtl : TextDirection.ltr;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Ask a follow-up question...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      prefixIcon: Icon(
                        Icons.edit_outlined,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                    maxLines: 3,
                    minLines: 1,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: _loading ? null : _sendFollowUp,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _followCtrl.dispose();
    _scroll.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }
}

class _Bubble {
  final bool isUser;
  final String text;
  _Bubble({required this.isUser, required this.text});
}
