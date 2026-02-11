import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../Data/Model/User/user.model.dart';
import '../../../../Data/Model/User/users_enums.dart';
import '../../../../Data/Repositories/user.repo.dart';
import '../../../../app_colors.dart';
import '../../../../core/Services/Auth/auth.service.dart';
import '../../../../core/Services/Auth/src/Providers/auth_provider.dart';
import '../../../../core/utils/SnackBar/snackbar.helper.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/section_title.dart';
import '../../../authentication/presentation/pages/landing.screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? appUser;
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final allergyController = TextEditingController();

  bool isLoading = true;

  SkinType? selectedSkinType;
  ClimateType? selectedClimate;
  SkincareFrequency? selectedFrequency;
  SkincarePriority? selectedPriority;
  SunscreenUsage? selectedSunscreen;
  bool hasAllergies = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      setState(() {
        isLoading = true;
      });

      String? userId = AuthService(
        authProvider: FirebaseAuthProvider(firebaseAuth: FirebaseAuth.instance),
      ).getCurrentUserId();

      print('🔍 Loading user data for userId: $userId');

      if (userId != null) {
        print('📡 Calling UserRepo().readSingle...');
        UserModel? userData = await UserRepo().readSingle('Users', userId);
        print('📊 User data loaded: $userData');

        if (userData != null) {
          print('✅ User data found, updating UI...');
          print('📝 Name: ${userData.name}');
          print('📧 Email: ${userData.email}');
          print('📱 Phone: ${userData.phoneNumber}');
        } else {
          print('❌ User data is null');
        }

        if (mounted) {
          setState(() {
            appUser = userData;
            if (userData != null) {
              nameController.text = userData.name;
              emailController.text = userData.email;
              phoneController.text = userData.phoneNumber;
              allergyController.text = userData.allergyDescription ?? "";
              selectedSkinType = userData.skinType;
              selectedClimate = userData.climate;
              selectedFrequency = userData.skincareFrequency;
              selectedPriority = userData.skincarePriority;
              selectedSunscreen = userData.sunscreenUsage;
              hasAllergies = userData.hasAllergies ?? false;
            }
            isLoading = false;
          });
        }
      } else {
        print('❌ No user ID found - user not authenticated');
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('You must be logged in to view profile'),
              backgroundColor: AppColors.mauve,
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      print('💥 Error loading user data: $e');
      print('📍 Stack trace: $stackTrace');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading profile: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isLoading) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: const Text("Profile"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _loadUserData,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Profile',
          ),
          TextButton(
            onPressed: () {
              AuthService(
                authProvider:
                    FirebaseAuthProvider(firebaseAuth: FirebaseAuth.instance),
              ).signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LandingScreen()),
                (route) => false,
              );
            },
            child: Text(
              'Sign Out',
              style: TextStyle(
                color: colorScheme.error,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SectionTitle(title: "Account Info"),
                    const SizedBox(height: 16),
                    _buildTextField(nameController, "Name"),
                    const SizedBox(height: 16),
                    _buildTextField(emailController, "Email", readOnly: true),
                    const SizedBox(height: 16),
                    _buildTextField(phoneController, "Phone Number"),
                    const SizedBox(height: 32),
                    const SectionTitle(title: "Skincare Profile"),
                    const SizedBox(height: 16),
                    _buildDropdown<SkinType>(
                      label: "Skin Type",
                      value: selectedSkinType,
                      items: SkinType.values,
                      itemToString: (e) =>
                          e.name.replaceAll("_", " ").toUpperCase(),
                      onChanged: (val) =>
                          setState(() => selectedSkinType = val),
                    ),
                    _buildDropdown<ClimateType>(
                      label: "Climate in your area",
                      value: selectedClimate,
                      items: ClimateType.values,
                      itemToString: (e) =>
                          e.name.replaceAll("_", " ").toUpperCase(),
                      onChanged: (val) => setState(() => selectedClimate = val),
                    ),
                    Row(
                      children: [
                        const Text("Allergies to skincare?"),
                        const Spacer(),
                        Switch(
                          inactiveThumbColor: Colors.white,
                          value: hasAllergies,
                          onChanged: (val) =>
                              setState(() => hasAllergies = val),
                        )
                      ],
                    ),
                    if (hasAllergies)
                      Column(
                        children: [
                          _buildTextField(
                              allergyController, "Allergy Description"),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    _buildDropdown<SkincareFrequency>(
                      label: "Skincare Frequency",
                      value: selectedFrequency,
                      items: SkincareFrequency.values,
                      itemToString: (e) =>
                          e.name.replaceAll("_", " ").toUpperCase(),
                      onChanged: (val) =>
                          setState(() => selectedFrequency = val),
                    ),
                    _buildDropdown<SkincarePriority>(
                      label: "Skincare Priority",
                      value: selectedPriority,
                      items: SkincarePriority.values,
                      itemToString: (e) =>
                          e.name.replaceAll("_", " ").toUpperCase(),
                      onChanged: (val) =>
                          setState(() => selectedPriority = val),
                    ),
                    _buildDropdown<SunscreenUsage>(
                      label: "Do you use sunscreen?",
                      value: selectedSunscreen,
                      items: SunscreenUsage.values,
                      itemToString: (e) =>
                          e.name.replaceAll("_", " ").toUpperCase(),
                      onChanged: (val) =>
                          setState(() => selectedSunscreen = val),
                    ),
                    const SizedBox(height: 42),
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        title: "Save",
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            appUser?.name = nameController.text;
                            appUser?.phoneNumber = phoneController.text;
                            appUser?.skinType = selectedSkinType;
                            appUser?.climate = selectedClimate;
                            appUser?.hasAllergies = hasAllergies;
                            appUser?.allergyDescription =
                                hasAllergies ? allergyController.text : null;
                            appUser?.skincareFrequency = selectedFrequency;
                            appUser?.skincarePriority = selectedPriority;
                            appUser?.sunscreenUsage = selectedSunscreen;

                            await UserRepo().updateSingle(
                                'Users', appUser!.id, appUser!.toMap());
                            SnackbarHelper.showTemplated(
                              context,
                              title: "Profile updated successfully!",
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool readOnly = false}) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      enabled: !readOnly,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.lightPeach,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (val) {
        if (!readOnly && (val == null || val.isEmpty)) {
          return '$label cannot be empty';
        }
        return null;
      },
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required String Function(T) itemToString,
    required void Function(T?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.lightPeach,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<T>(
        value: value,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
        icon: const Icon(Icons.arrow_drop_down),
        dropdownColor: AppColors.lightPeach,
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(itemToString(e)),
              ),
            )
            .toList(),
        onChanged: onChanged,
        validator: (val) => val == null ? 'Please select $label' : null,
      ),
    );
  }
}
