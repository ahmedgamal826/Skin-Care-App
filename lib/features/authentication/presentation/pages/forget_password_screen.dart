import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/Services/Auth/auth.service.dart';
import '../../../../core/Services/Auth/src/Providers/auth_provider.dart';
import '../../../../core/localization/app_localizations.dart';
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
  bool _isLoading = false;

  final AuthService _authService = AuthService(
    authProvider: FirebaseAuthProvider(
      firebaseAuth: FirebaseAuth.instance,
    ),
  );

  void _resetPassword() async {
    final email = _emailController.text.trim();
    final loc = AppLocalizations.of(context);
    print('🔄 Reset Password: Starting reset for email: $email');

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        print('📧 Reset Password: Calling AuthService.resetPassword...');
        final result = await _authService.resetPassword(email);
        print('📊 Reset Password: Result: $result');

        if (result) {
          print('✅ Reset Password: Success! Email sent');
          SnackbarHelper.showTemplated(context,
              title: loc.translate('reset_email_sent'));
          Navigator.pop(context);
        } else {
          print('❌ Reset Password: Failed to send email');
          SnackbarHelper.showError(context,
              title: loc.translate('reset_email_failed'));
        }
      } catch (e) {
        print('💥 Reset Password: Error occurred: $e');
        SnackbarHelper.showError(context,
            title:
                "${loc.translate('reset_password_failed')}: ${e.toString()}");
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      print('❌ Reset Password: Form validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(loc.translate('reset_password'))),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
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
                  String pattern =
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&\'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(value)) {
                    return loc.translate('please_enter_valid_email');
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
            onPressed: _isLoading ? null : _resetPassword,
            title:
                _isLoading ? "" : loc.translate('reset_password'),
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
      ),
    );
  }
}
