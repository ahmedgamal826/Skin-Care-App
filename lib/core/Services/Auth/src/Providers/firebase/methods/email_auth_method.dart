import '../../../../interfaces/auth_method.dart';

/// Email-based authentication method implementation.
class EmailAuthMethod implements AuthMethod {
  final String email;
  final String password;

  EmailAuthMethod({
    required this.email,
    required this.password,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }
}
