import 'dart:convert';

import '../../../nucleo/rede/api_client.dart';
import '../dominio/user_role.dart';

class AuthRepository {
  AuthRepository(this._client);

  final ApiClient _client;

  Future<String> login({required String login, required String senha}) async {
    final data = await _client.postJson('/auth/login', {
      'login': login,
      'senha': senha,
    });
    if (data is Map && data['token'] is String) {
      return data['token'] as String;
    }
    throw ApiClientException('Resposta de login sem token.');
  }

  Future<void> register({
    required String login,
    required String senha,
    required UserRole role,
  }) async {
    await _client.postJson('/auth/register', {
      'login': login,
      'senha': senha,
      'role': role.apiValue,
    });
  }

  UserRole? roleFromJwt(String token) {
    final parts = token.split('.');
    if (parts.length < 2) return null;

    try {
      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final json = jsonDecode(payload);
      if (json is! Map<String, dynamic>) return null;

      final directRole = json['role'] ?? json['userRole'];
      if (directRole is String) return UserRole.fromApi(directRole);

      final authorities = json['authorities'] ?? json['roles'];
      if (authorities is List && authorities.isNotEmpty) {
        return UserRole.fromApi(authorities.first.toString());
      }
    } catch (_) {
      return null;
    }

    return null;
  }
}
