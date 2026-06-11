import 'user_role.dart';

class AuthSession {
  const AuthSession({
    required this.token,
    required this.login,
    required this.role,
  });

  final String token;
  final String login;
  final UserRole role;
}
