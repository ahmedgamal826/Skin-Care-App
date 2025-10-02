import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/Services/Auth/auth.service.dart';
import '../../../../core/Services/Auth/src/Providers/auth_provider.dart';
import '../../../../core/utils/SnackBar/snackbar.helper.dart';
import '../../../../core/widgets/primary_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final AuthService _authService = AuthService(
    authProvider: FirebaseAuthProvider(
      firebaseAuth: FirebaseAuth.instance,
    ),
  );

  void _resetPassword() async {
    final email = _emailController.text.trim();
    if (_formKey.currentState!.validate()) {
      try {
        final result = await _authService.resetPassword(email);

        if (result) {
          SnackbarHelper.showTemplated(context,
              title:
                  'An email has been sent successfully to reset the password');
          Navigator.pop(context);
        } else {
          SnackbarHelper.showError(context,
              title: "Failed to send an email to reset the password");
        }
      } catch (e) {
        SnackbarHelper.showError(context,
            title: "Reset password failed: ${e.toString()}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: "exa@example.com",
                  labelText: "Email",
                  border: OutlineInputBorder(),
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            onPressed: _resetPassword,
            title: 'Reset Password',
          ),
        ),
      ),
    );
  }
}
