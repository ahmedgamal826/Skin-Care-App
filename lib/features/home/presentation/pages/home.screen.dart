import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../../../Data/Model/User/user.model.dart';
import '../../../../app_colors.dart';
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

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SkinAnalysisResultScreen(
          imageFile: imageFile,
        ),
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
        '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';

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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: Text(
          'Welcome back 👋',
          style: TextStyle(color: colorScheme.onSurface),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.person_2_outlined,
              color: colorScheme.onSurfaceVariant,
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
              // Banner container
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.softPink,
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
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: AppColors.darkPink,
                                  ),
                            ),
                            TextSpan(
                              text: "product for your skin",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(
                                    color: AppColors.darkPink,
                                  ),
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

              // Server status indicator
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: serverConnected
                      ? AppColors.lightMint
                      : AppColors.softPink,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        serverConnected ? AppColors.mintTeal : AppColors.mauve,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      serverConnected ? Icons.check_circle : Icons.error,
                      color: serverConnected
                          ? AppColors.darkTeal
                          : AppColors.darkPink,
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
                              ? AppColors.darkTeal
                              : AppColors.darkPink,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _checkServerStatus,
                      child: Text(
                        'Recheck',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Scan face button
              GestureDetector(
                onTap: () async {
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
                    color: AppColors.lightPeach,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.outlineVariant,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.face_retouching_natural,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Scan your face with AI",
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),

              // Loading indicator
              if (isLoading)
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Analyzing skin...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
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
