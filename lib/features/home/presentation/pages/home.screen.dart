// Modified HomeScreen with language selection for ChatGPT prompt
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../../Data/Model/User/user.model.dart';
import '../../../profile/presentation/pages/profile.screen.dart';
import '../widgets/disease_detection_card.dart';
import 'recommended_products_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? appUser;
  bool isLoading = false;
  String? userId;

  final TextEditingController product1Controller = TextEditingController();
  final TextEditingController product2Controller = TextEditingController();
  String? responseMessage;
  String selectedLanguage = 'العربية';

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
              GestureDetector(
                onTap: () async {
                  final picker = ImagePicker();
                  final XFile? pickedFile = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 92,
                  );
                  if (pickedFile == null) return;

                  final File image = File(pickedFile.path);

                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecommendedProductsScreen(
                          imageFile: image,
                        ),
                      ),
                    );
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
             
              // Row(
              //   children: [
              //     const Text("Language: "),
              //     const SizedBox(width: 12),
              //     DropdownButton<String>(
              //       value: selectedLanguage,
              //       items: ["العربية", "English"]
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
