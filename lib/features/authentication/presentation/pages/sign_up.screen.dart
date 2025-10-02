//t2 Core Packages Imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../Data/Model/User/user.model.dart' as User;
import '../../../../Data/Repositories/user.repo.dart';
import '../../../../core/Services/Auth/auth.service.dart';
import '../../../../core/Services/Auth/models/auth.model.dart';
import '../../../../core/Services/Auth/src/Providers/auth_provider.dart';
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
  //SECTION - Stateless functions
  //!SECTION

  //SECTION - Action Callbacks
  //!SECTION

  @override
  Widget build(BuildContext context) {
    //SECTION - Build Setup
    //t2 -Values
    // double w = MediaQuery.of(context).size.width;
    // double h = MediaQuery.of(context).size.height;
    //t2 -Values
    //
    //t2 -Widgets
    //t2 -Widgets
    //!SECTION

    //SECTION - Build Return
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Account',
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
                    'Healthy skin starts here',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: "exa@example.com",
                      labelText: "Email",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email address';
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
                      hintText: "Enter Your Password",
                      labelText: "Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
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
                        return 'The password cannot be empty';
                      } else if (!hasMinLength) {
                        return 'The password must be at least 8 characters long';
                      } else if (!hasUpperCase) {
                        return 'The password must contain at least one uppercase letter';
                      } else if (!hasLowerCase) {
                        return 'The password must contain at least one lowercase letter';
                      } else if (!hasNumber) {
                        return 'The password must contain at least one number';
                      } else if (!hasSpecialChar) {
                        return 'The password must contain at least one special character';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _fNameController,
                    decoration: const InputDecoration(
                      hintText: "Enter Your Name",
                      labelText: "Name",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'The name cannot be empty';
                      } else if (value.length < 3) {
                        return 'The name must be at least 3 characters long';
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
                    decoration: const InputDecoration(
                      hintText: "Enter Your Phone Number",
                      labelText: "mobile number",
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      // Accept any 11-digit phone number
                      if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                        return 'Please enter a valid 11-digit phone number';
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
                                        title: 'Failed to sign up');
                                  }
                                } catch (e) {
                                  SnackbarHelper.showError(context,
                                      title: 'Sign up failed: ${e.toString()}');
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                              }
                            },
                      title: _isLoading ? "" : "Sign up",
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
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
                          text: 'Already have an account? ',
                          style: const TextStyle(
                            color: Color(0xff939393),
                          ),
                          children: <InlineSpan>[
                            TextSpan(
                              text: 'Log in',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
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
    //!SECTION
  }

  @override
  void dispose() {
    //SECTION - Disposable variables
    //!SECTION
    super.dispose();
  }
}
