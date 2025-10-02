import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Data/Model/User/user.model.dart';
import '../../../../Data/Model/User/users_enums.dart';
import '../../../../Data/Repositories/user.repo.dart';
import '../../../../core/Services/Auth/auth.service.dart';
import '../../../../core/Services/Auth/src/Providers/auth_provider.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../home/presentation/pages/home.screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Quiz answers
  SkinType? skinType;
  ClimateType? climate;
  bool? hasAllergies;
  String? allergyDescription;
  SkincareFrequency? skincareFrequency;
  SkincarePriority? skincarePriority;
  SunscreenUsage? sunscreenUsage;

  final TextEditingController _allergyController = TextEditingController();

  bool get canProceed {
    switch (_currentPage) {
      case 0:
        return skinType != null;
      case 1:
        return climate != null;
      case 2:
        return hasAllergies != null &&
            (hasAllergies == false ||
                (hasAllergies == true &&
                    allergyDescription?.isNotEmpty == true));
      case 3:
        return skincareFrequency != null;
      case 4:
        return skincarePriority != null;
      case 5:
        return sunscreenUsage != null;
      default:
        return false;
    }
  }

  void nextPage() {
    if (_currentPage < 6) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage++);
    } else {
      submit();
    }
  }

  Future<void> submit() async {
    try {
      String? userId = AuthService(
        authProvider: FirebaseAuthProvider(firebaseAuth: FirebaseAuth.instance),
      ).getCurrentUserId();

      if (userId != null) {
        UserModel? userModel = await UserRepo().readSingle('Users', userId);

        if (userModel != null) {
          userModel = userModel.copyWith(
            allergyDescription:
                hasAllergies == true ? allergyDescription : null,
            climate: climate,
            hasAllergies: hasAllergies,
            sunscreenUsage: sunscreenUsage,
            skinType: skinType,
            skincarePriority: skincarePriority,
            skincareFrequency: skincareFrequency,
          );

          await UserRepo()
              .updateSingle('Users', userModel.id, userModel.toMap());
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('hasCompletedQuiz', true);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const HomeScreen(),
            ),
            (route) => false,
          );
        } else {
          // Handle case where user model is null
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to load user data. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Handle case where user is not authenticated
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You must be logged in to complete the quiz.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting quiz: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget buildOptionTile<T>({
    required String text,
    required T value,
    required T? selectedValue,
    required VoidCallback onTap,
  }) {
    final isSelected = value == selectedValue;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget buildPage({
    required String question,
    required List<Widget> options,
    bool showTextField = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text("Let’s Get to Know Your Skin",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Text(question, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          ...options,
          if (showTextField)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: TextField(
                controller: _allergyController,
                decoration: InputDecoration(
                  hintText: "what’s your allergies ?",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
                onChanged: (val) => allergyDescription = val,
              ),
            ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              title: _currentPage == 5 ? "Submit" : "Next",
              onPressed:
                  canProceed ? (_currentPage == 5 ? submit : nextPage) : null,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EDE8),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // Page 1 - Skin Type
            buildPage(
              question: "What is your skin type?",
              options: SkinType.values.map((e) {
                return buildOptionTile<SkinType>(
                  text: e.name,
                  value: e,
                  selectedValue: skinType,
                  onTap: () {
                    setState(() => skinType = e);
                  },
                );
              }).toList(),
            ),

            // Page 2 - Climate
            buildPage(
              question: "How would you describe the climate in your area?",
              options: ClimateType.values.map((e) {
                return buildOptionTile<ClimateType>(
                  text: e.name,
                  value: e,
                  selectedValue: climate,
                  onTap: () {
                    setState(() => climate = e);
                  },
                );
              }).toList(),
            ),

            // Page 3 - Allergies
            buildPage(
              question: "Do you have allergies to any skincare ingredients?",
              options: [
                buildOptionTile<bool>(
                  text: "Yes",
                  value: true,
                  selectedValue: hasAllergies,
                  onTap: () {
                    setState(() => hasAllergies = true);
                  },
                ),
                buildOptionTile<bool>(
                  text: "No",
                  value: false,
                  selectedValue: hasAllergies,
                  onTap: () {
                    setState(() {
                      hasAllergies = false;
                      allergyDescription = null;
                      _allergyController.clear();
                    });
                  },
                ),
              ],
              showTextField: hasAllergies == true,
            ),

            // Page 4 - Skincare Frequency
            buildPage(
              question: "How often do you take care of your skin?",
              options: SkincareFrequency.values.map((e) {
                return buildOptionTile<SkincareFrequency>(
                  text: e.name,
                  value: e,
                  selectedValue: skincareFrequency,
                  onTap: () {
                    setState(() => skincareFrequency = e);
                  },
                );
              }).toList(),
            ),

            // Page 5 - Skincare Priority
            buildPage(
              question:
                  "What is the most important thing you look for in skincare products?",
              options: SkincarePriority.values.map((e) {
                return buildOptionTile<SkincarePriority>(
                  text: e.name,
                  value: e,
                  selectedValue: skincarePriority,
                  onTap: () {
                    setState(() => skincarePriority = e);
                  },
                );
              }).toList(),
            ),

            // Page 6 - Sunscreen Usage
            buildPage(
              question: "Do you use sunscreen daily?",
              options: SunscreenUsage.values.map((e) {
                return buildOptionTile<SunscreenUsage>(
                  text: e.name,
                  value: e,
                  selectedValue: sunscreenUsage,
                  onTap: () {
                    setState(() => sunscreenUsage = e);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringCasing on String {
  String capitalize() =>
      this[0].toUpperCase() + substring(1).replaceAll("_", " ");
}
