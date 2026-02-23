import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Data/Model/User/user.model.dart';
import '../../../../Data/Model/User/users_enums.dart';
import '../../../../Data/Repositories/user.repo.dart';
import '../../../../app_colors.dart';
import '../../../../core/Services/Auth/auth.service.dart';
import '../../../../core/Services/Auth/src/Providers/auth_provider.dart';
import '../../../../core/localization/app_localizations.dart';
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
    final loc = AppLocalizations.of(context);
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loc.translate('failed_load_user')),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.translate('must_login_quiz')),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${loc.translate('error_submitting_quiz')}: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
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
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lightMint : AppColors.lightPeach,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? AppColors.darkTeal : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget buildPage({
    required String question,
    required List<Widget> options,
    bool showTextField = false,
  }) {
    final loc = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            loc.translate('get_to_know_skin'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            question,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          ...options,
          if (showTextField)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: TextField(
                controller: _allergyController,
                decoration: InputDecoration(
                  hintText: loc.translate('whats_allergies'),
                  filled: true,
                  fillColor: AppColors.lightPeach,
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
              title: _currentPage == 5
                  ? loc.translate('submit')
                  : loc.translate('next'),
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
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // Page 1 - Skin Type
            buildPage(
              question: loc.translate('what_skin_type'),
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
              question: loc.translate('describe_climate'),
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
              question: loc.translate('have_allergies'),
              options: [
                buildOptionTile<bool>(
                  text: loc.translate('yes'),
                  value: true,
                  selectedValue: hasAllergies,
                  onTap: () {
                    setState(() => hasAllergies = true);
                  },
                ),
                buildOptionTile<bool>(
                  text: loc.translate('no'),
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
              question: loc.translate('how_often_skincare'),
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
              question: loc.translate('important_skincare'),
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
              question: loc.translate('use_sunscreen_daily'),
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
