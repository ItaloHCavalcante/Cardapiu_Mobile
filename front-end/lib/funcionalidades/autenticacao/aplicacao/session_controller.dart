import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../nucleo/rede/api_client.dart';
import '../dados/auth_repository.dart';
import '../dominio/auth_session.dart';
import '../dominio/user_role.dart';

class SessionController extends ChangeNotifier {
  SessionController(this._repository, this._client);

  final AuthRepository _repository;
  final ApiClient _client;

  bool isBootstrapping = true;
  bool isBusy = false;
  String? error;
  AuthSession? session;

  bool get isAuthenticated => session != null;

  Future<void> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth.token');
    final login = prefs.getString('auth.login');
    final roleValue = prefs.getString('auth.role');

    if (token != null && login != null && roleValue != null) {
      session = AuthSession(
        token: token,
        login: login,
        role: _repository.roleFromJwt(token) ?? UserRole.fromApi(roleValue),
      );
      _client.setToken(token);
    }

    isBootstrapping = false;
    notifyListeners();
  }

  Future<void> login({
    required String login,
    required String senha,
    required UserRole selectedRole,
  }) async {
    await _run(() async {
      final token = await _repository.login(login: login, senha: senha);
      final role = _repository.roleFromJwt(token) ?? selectedRole;
      session = AuthSession(token: token, login: login, role: role);
      _client.setToken(token);
      await _persist();
    });
  }

  Future<void> registerAndLogin({
    required String login,
    required String senha,
    required UserRole role,
  }) async {
    await _run(() async {
      await _repository.register(login: login, senha: senha, role: role);
      final token = await _repository.login(login: login, senha: senha);
      final resolvedRole = _repository.roleFromJwt(token) ?? role;
      session = AuthSession(token: token, login: login, role: resolvedRole);
      _client.setToken(token);
      await _persist();
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth.token');
    await prefs.remove('auth.login');
    await prefs.remove('auth.role');
    _client.setToken(null);
    session = null;
    notifyListeners();
  }

  Future<void> _persist() async {
    final current = session;
    if (current == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth.token', current.token);
    await prefs.setString('auth.login', current.login);
    await prefs.setString('auth.role', current.role.apiValue);
  }

  Future<void> _run(Future<void> Function() action) async {
    isBusy = true;
    error = null;
    notifyListeners();

    try {
      await action();
    } catch (exception) {
      error = exception.toString();
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }
}
