import '../../../nucleo/rede/api_client.dart';

class DelivererRepository {
  DelivererRepository(this._client);

  final ApiClient _client;

  Future<void> createProfile({
    required String placaVeiculo,
    required String telefone,
    required int usuarioId,
  }) async {
    await _client.postJson('/entregadores', {
      'placaVeiculo': placaVeiculo,
      'telefone': telefone,
      'usuarioId': usuarioId,
    });
  }

  Future<List<Map<String, dynamic>>> availableDeliverers() async {
    final data = await _client.getJson('/entregadores/disponiveis');
    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return const [];
  }
}
