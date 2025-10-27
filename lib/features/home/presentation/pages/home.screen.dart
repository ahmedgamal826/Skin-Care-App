import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import '../../../../Data/Model/User/user.model.dart';
import '../../../../core/Services/API/skin_care_api_service.dart';
import '../../../profile/presentation/pages/profile.screen.dart';
import '../../../skin_analysis/presentation/pages/skin_analysis_result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? appUser;
  bool isLoading = false;
  String? userId;
  bool serverConnected = false;

  final TextEditingController product1Controller = TextEditingController();
  final TextEditingController product2Controller = TextEditingController();
  String? responseMessage;
  String selectedLanguage = 'English';

  // إضافة الخدمة الجديدة
  final SkinCareApiService _skinCareApiService = SkinCareApiService();

  @override
  void initState() {
    super.initState();
    _checkServerStatus();
  }

  /// Check server status
  Future<void> _checkServerStatus() async {
    try {
      final isConnected = await _skinCareApiService.checkServerStatus();
      setState(() {
        serverConnected = isConnected;
      });
    } catch (e) {
      setState(() {
        serverConnected = false;
      });
    }
  }

  /// Analyze skin using the new service and navigate to result screen
  Future<void> _analyzeSkinWithNewService(XFile imageFile) async {
    if (!mounted) return;
    
    // Navigate to the new result screen which will handle analysis
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SkinAnalysisResultScreen(
          imageFile: imageFile,
        ),
      ),
    );
  }

  /// Show analysis results
  void _showAnalysisResults(CompleteAnalysisResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Skin Analysis Results'),
        content: SizedBox(
          width: double.maxFinite,
          height: 500,
          child: Column(
            children: [
              // Analysis information
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Skin Type: ${result.skinType}'),
                      Text('Concern: ${result.concern}'),
                      const SizedBox(height: 8),
                      Text(
                          'Skin Type Confidence: ${result.confidence.skinTypeConfidencePercentage}%'),
                      Text(
                          'Concern Confidence: ${result.confidence.concernConfidencePercentage}%'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Recommendations
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recommendations:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
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
                                  Text('Type: ${product.productType}'),
                                  Text('Price: ${product.price}'),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.open_in_new),
                                onPressed: () =>
                                    _openProductUrl(product.productUrl),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Open product URL with better error handling
  Future<void> _openProductUrl(String url) async {
    try {
      if (kDebugMode) {
        print('Attempting to open URL: $url');
      }

      // Try to parse and encode URL properly
      var uri = Uri.tryParse(url);

      if (uri == null) {
        // If parsing fails, try to manually create URI with proper encoding
        try {
          uri = Uri.parse(url.replaceAll(' ', '%20'));
        } catch (e) {
          _showErrorMessage('Invalid URL format: $url');
          return;
        }
      }

      // Try to launch URL directly
      try {
        // Try platform default first (let system choose app)
        await launchUrl(
          uri,
          mode: LaunchMode.platformDefault,
        );
        if (kDebugMode) {
          print('Successfully launched URL: $uri');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Failed to launch with platform default, trying external: $e');
        }
        // Fallback: try external application
        try {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        } catch (e2) {
          if (kDebugMode) {
            print('Failed to launch URL: $e2');
          }
          _showErrorMessage('Cannot open link. Please install a web browser.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error opening URL: $e');
      }
      _showErrorMessage('Error opening link: ${e.toString()}');
    }
  }

  /// Show error message
  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> checkConflict() async {
    final product1 = product1Controller.text.trim();
    final product2 = product2Controller.text.trim();
    if (product1.isEmpty || product2.isEmpty) return;

    setState(() => isLoading = true);

    final prompt = selectedLanguage == 'العربية'
        ? "بصفتك خبيرًا في العناية بالبشرة، هل هناك أي تعارض بين المكونات أو طريقة الاستخدام في هذين المنتجين: '$product1' و '$product2'؟ من فضلك اشرح ذلك بشكل واضح ومختصر، وبأسلوب ودود."
        : "As a skincare expert, tell me if there is any ingredient or usage conflict between these two skincare products: '$product1' and '$product2'. Explain clearly and briefly. Respond in a friendly tone.";

    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final apiKey =
        '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'; // Replace this

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: utf8.encode(jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "user", "content": prompt}
          ]
        })),
      );

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedResponse);
        final msg = data['choices'][0]['message']['content'];

        setState(() => responseMessage = msg);
      } else {
        setState(() => responseMessage = 'Something went wrong.');
      }
    } catch (e) {
      setState(() => responseMessage = 'Error: \$e');
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0E8E6),
      appBar: AppBar(
        backgroundColor: const Color(0xffF0E8E6),
        title: const Text('Welcome back 👋'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.person_2_outlined,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 24,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const ProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffEEC6BA),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Image.asset("assets/images/home_img.png"),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Find the right\n",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            TextSpan(
                              text: "product for your skin",
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.start,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // مؤشر حالة الخادم
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: serverConnected
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: serverConnected ? Colors.green : Colors.red,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      serverConnected ? Icons.check_circle : Icons.error,
                      color: serverConnected ? Colors.green : Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        serverConnected
                            ? 'Server Connected - Ready for Analysis'
                            : 'Server Disconnected - Make sure Flask API is running',
                        style: TextStyle(
                          color: serverConnected
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _checkServerStatus,
                      child: const Text('Recheck'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              GestureDetector(
                onTap: () async {
                  // Open gallery directly
                  final picker = ImagePicker();
                  final XFile? pickedFile = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 85,
                  );
                  if (pickedFile != null) {
                    await _analyzeSkinWithNewService(pickedFile);
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.face_retouching_natural),
                      SizedBox(width: 12),
                      Expanded(child: Text("Scan your face with AI")),
                      Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),

              // Loading indicator
              if (isLoading)
                Container(
                  padding: const EdgeInsets.all(20),
                  child: const Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Analyzing skin...',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),

              // Row(
              //   children: [
              //     const Text("Language: "),
              //     const SizedBox(width: 12),
              //     DropdownButton<String>(
              //       value: selectedLanguage,
              //       items: ["Arabic", "English"]
              //           .map((lang) => DropdownMenuItem(
              //                 value: lang,
              //                 child: Text(lang),
              //               ))
              //           .toList(),
              //       onChanged: (val) {
              //         setState(() => selectedLanguage = val!);
              //       },
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 12),
              // TextField(
              //   controller: product1Controller,
              //   decoration: const InputDecoration(
              //     labelText: 'First Product Name',
              //     border: OutlineInputBorder(),
              //   ),
              // ),
              // const SizedBox(height: 12),
              // TextField(
              //   controller: product2Controller,
              //   decoration: const InputDecoration(
              //     labelText: 'Second Product Name',
              //     border: OutlineInputBorder(),
              //   ),
              // ),
              // const SizedBox(height: 12),
              // SizedBox(
              //   width: double.infinity,
              //   child: PrimaryButton(
              //     onPressed: isLoading ? null : checkConflict,
              //     title: isLoading ? "Checking..." : "Check Conflict",
              //   ),
              // ),
              // if (responseMessage != null) ...[
              //   const SizedBox(height: 16),
              //   Container(
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(12),
              //       border: Border.all(color: Colors.grey.shade300),
              //     ),
              //     padding: const EdgeInsets.all(12),
              //     child: Text(
              //       responseMessage!,
              //       style: Theme.of(context).textTheme.bodyLarge,
              //     ),
              //   )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    product1Controller.dispose();
    product2Controller.dispose();
    super.dispose();
  }
}
