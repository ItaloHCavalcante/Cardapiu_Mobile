import '../../../nucleo/rede/api_client.dart';
import '../dominio/product.dart';
import '../dominio/restaurant.dart';

class MenuRepository {
  MenuRepository(this._client);

  final ApiClient _client;

  Future<List<Restaurant>> fetchRestaurants() async {
    final data = await _client.getJson('/restaurantes');
    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => Restaurant.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    throw ApiClientException('Resposta inesperada ao listar restaurantes.');
  }

  Future<List<Product>> fetchProducts(int restaurantId) async {
    final data = await _client.getJson('/produtos/restaurante/$restaurantId');
    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => Product.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    throw ApiClientException('Resposta inesperada ao listar produtos.');
  }
}
