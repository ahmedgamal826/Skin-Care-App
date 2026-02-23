//t2 Core Packages Imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../Data/Model/User/user.model.dart' as User;
import '../../../../Data/Repositories/user.repo.dart';

import '../../../../core/Services/Auth/auth.service.dart';
import '../../../../core/Services/Auth/models/auth.model.dart';
import '../../../../core/Services/Auth/src/Providers/auth_provider.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/SnackBar/snackbar.helper.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../quiz/presentation/screens/quiz_screen.dart';
import 'sign_in.screen.dart';

//t2 Dependencies Imports
//t3 Services
//t3 Models
//t1 Exports
class SignUpScreen extends StatefulWidget {
  //SECTION - Widget Arguments
  //!SECTION
  //
  const SignUpScreen({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //
  //SECTION - State Variables
  //t2 --Controllers
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool hasMinLength = false;
  bool hasUpperCase = false;
  bool _obscurePassword = true;
  bool hasLowerCase = false;
  bool hasNumber = false;
  bool hasSpecialChar = false;
  bool _isLoading = false;

  //t2 --Controllers
  //
  //t2 --State
  //t2 --State
  //
  //t2 --Constants
  final _formKey = GlobalKey<FormState>();

  //t2 --Constants
  //!SECTION

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.translate('create_account'),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.translate('healthy_skin_starts'),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: loc.translate('email_hint'),
                      labelText: loc.translate('email'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return loc.translate('please_enter_email');
                      }
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!emailRegex.hasMatch(value)) {
                        return loc
                            .translate('please_enter_valid_email_address');
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: loc.translate('enter_password'),
                      labelText: loc.translate('password'),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        hasMinLength = value.length >= 8;
                        hasUpperCase = RegExp(r'[A-Z]').hasMatch(value);
                        hasLowerCase = RegExp(r'[a-z]').hasMatch(value);
                        hasNumber = RegExp(r'[0-9]').hasMatch(value);
                        hasSpecialChar =
                            RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return loc.translate('password_empty');
                      } else if (!hasMinLength) {
                        return loc.translate('password_min_length');
                      } else if (!hasUpperCase) {
                        return loc.translate('password_uppercase');
                      } else if (!hasLowerCase) {
                        return loc.translate('password_lowercase');
                      } else if (!hasNumber) {
                        return loc.translate('password_number');
                      } else if (!hasSpecialChar) {
                        return loc.translate('password_special_char');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _fNameController,
                    decoration: InputDecoration(
                      hintText: loc.translate('enter_name'),
                      labelText: loc.translate('name'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return loc.translate('name_empty');
                      } else if (value.length < 3) {
                        return loc.translate('name_min_length');
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      hintText: loc.translate('enter_phone'),
                      labelText: loc.translate('mobile_number'),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return loc.translate('please_enter_phone');
                      }
                      if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                        return loc.translate('invalid_phone');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });

                                try {
                                  AuthService authService = AuthService(
                                    authProvider: FirebaseAuthProvider(
                                      firebaseAuth: FirebaseAuth.instance,
                                    ),
                                  );

                                  AuthModel? authModel =
                                      await authService.signUp(
                                    _emailController.text.trim(),
                                    _passwordController.text,
                                  );

                                  if (authModel != null) {
                                    print(
                                        '🎉 Sign up successful! User ID: ${authModel.uid}');

                                    User.UserModel user = User.UserModel(
                                      id: authModel.uid,
                                      email: _emailController.text,
                                      name: _fNameController.text,
                                      phoneNumber: _phoneNumberController.text,
                                    );

                                    print(
                                        '👤 Creating user document in Firestore...');
                                    String? result = await UserRepo()
                                        .createSingle('Users', authModel.uid,
                                            user.toMap());

                                    if (result != null) {
                                      print(
                                          '✅ User document created successfully!');
                                    } else {
                                      print('❌ Failed to create user document');
                                    }

                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            const QuizScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  } else {
                                    SnackbarHelper.showError(context,
                                        title:
                                            loc.translate('failed_sign_up'));
                                  }
                                } catch (e) {
                                  SnackbarHelper.showError(context,
                                      title:
                                          '${loc.translate('sign_up_failed')}: ${e.toString()}');
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                              }
                            },
                      title:
                          _isLoading ? "" : loc.translate('sign_up'),
                      child: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    colorScheme.onPrimary),
                              ),
                            )
                          : null,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const SignInScreen(),
                          ),
                        );
                      },
                      child: Text.rich(
                        TextSpan(
                          text: loc.translate('already_have_account_login'),
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          children: <InlineSpan>[
                            TextSpan(
                              text: loc.translate('log_in_link'),
                              style: TextStyle(
                                color: colorScheme.tertiary,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
