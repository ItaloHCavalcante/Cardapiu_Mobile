import '../../../nucleo/rede/api_client.dart';
import '../dominio/product.dart';

class MenuRepository {
  MenuRepository(this._client);

  final ApiClient _client;

  Future<List<Product>> fetchProducts() async {
    final data = await _client.getJson('/produtos');
    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => Product.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    throw ApiClientException('Resposta inesperada ao listar produtos.');
  }
}
