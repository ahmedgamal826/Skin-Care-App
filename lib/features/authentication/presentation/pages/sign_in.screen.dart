//t2 Core Packages Imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/Services/Auth/auth.service.dart';
import '../../../../core/Services/Auth/models/auth.model.dart';
import '../../../../core/Services/Auth/src/Providers/auth_provider.dart';
import '../../../../core/Services/Auth/src/Providers/firebase/methods/email_auth_method.dart';
import '../../../../core/utils/SnackBar/snackbar.helper.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/tertiary_button.dart';
import '../../../home/presentation/pages/home.screen.dart';
import 'forget_password_screen.dart';
import 'sign_up.screen.dart';

//t2 Dependencies Imports
//t3 Services
//t3 Models
//t1 Exports
class SignInScreen extends StatefulWidget {
  //SECTION - Widget Arguments
  //!SECTION
  //
  const SignInScreen({
    super.key,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //SECTION - Build Setup
    //t2 -Values
    //double w = MediaQuery.of(context).size.width;
    //double h = MediaQuery.of(context).size.height;
    //t2 -Values
    //
    //t2 -Widgets
    //t2 -Widgets
    //!SECTION

    //SECTION - Build Return
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login to your Account',
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
                    'Log in to continue your journey',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(
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
                      String pattern =
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&\'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                      RegExp regex = RegExp(pattern);
                      if (!regex.hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: "Password",
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
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TertiaryButton(
                      title: "Forgot Password?",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const ForgotPasswordScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Instantiate the email authentication method
                          EmailAuthMethod emailAuthMethod = EmailAuthMethod(
                            email: _emailController.text.trim(),
                            password: _passwordController.text,
                          );

                          AuthService authService = AuthService(
                            authProvider: FirebaseAuthProvider(
                              firebaseAuth: FirebaseAuth.instance,
                            ),
                          );

                          try {
                            AuthModel? authModel =
                                await authService.signIn(emailAuthMethod);

                            if (authModel != null) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const HomeScreen(),
                                ),
                                (route) => false,
                              );
                            } else {
                              SnackbarHelper.showError(
                                context,
                                title: "Invalid email or password",
                              );
                            }
                          } catch (e) {
                            SnackbarHelper.showError(
                              context,
                              title: "Sign in failed: ${e.toString()}",
                            );
                          }
                        }
                      },
                      title: "Login",
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const SignUpScreen(),
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
                              text: 'Sign Up',
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
    );
    //!SECTION
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
