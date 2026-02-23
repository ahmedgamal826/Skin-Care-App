//t2 Core Packages Imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import '../../../../core/Services/Auth/auth.service.dart';
import '../../../../core/Services/Auth/models/auth.model.dart';
import '../../../../core/Services/Auth/src/Providers/auth_provider.dart';
import '../../../../core/Services/Auth/src/Providers/firebase/methods/email_auth_method.dart';
import '../../../../core/localization/app_localizations.dart';
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
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc.translate('login_to_account'),
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
                    loc.translate('login_continue_journey'),
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
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: loc.translate('password_hint'),
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
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TertiaryButton(
                      title: loc.translate('forgot_password'),
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
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });

                                try {
                                  EmailAuthMethod emailAuthMethod =
                                      EmailAuthMethod(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text,
                                  );

                                  AuthService authService = AuthService(
                                    authProvider: FirebaseAuthProvider(
                                      firebaseAuth: FirebaseAuth.instance,
                                    ),
                                  );

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
                                      title: loc.translate(
                                          'invalid_email_or_password'),
                                    );
                                  }
                                } catch (e) {
                                  SnackbarHelper.showError(
                                    context,
                                    title:
                                        "${loc.translate('sign_in_failed')}: ${e.toString()}",
                                  );
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                              }
                            },
                      title: _isLoading ? "" : loc.translate('login'),
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
                          text: loc.translate('already_have_account'),
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          children: <InlineSpan>[
                            TextSpan(
                              text: loc.translate('sign_up_link'),
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
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
