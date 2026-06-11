import '../../../nucleo/rede/api_client.dart';
import '../dominio/order_status.dart';
import '../dominio/order_summary.dart';

class OrderRepository {
  OrderRepository(this._client);

  final ApiClient _client;

  Future<OrderSummary> createOrder(Map<String, dynamic> request) async {
    final data = await _client.postJson('/pedidos', request);
    if (data is Map) {
      return OrderSummary.fromJson(Map<String, dynamic>.from(data));
    }
    throw ApiClientException('Resposta inesperada ao criar pedido.');
  }

  Future<OrderSummary> fetchOrder(int id) async {
    final data = await _client.getJson('/pedidos/$id');
    if (data is Map) {
      return OrderSummary.fromJson(Map<String, dynamic>.from(data));
    }
    throw ApiClientException('Pedido nao encontrado.');
  }

  Future<List<OrderSummary>> fetchMyActiveOrders() async {
    final data = await _client.getJson('/pedidos/meus-pedidos/ativos');
    return _parseOrderList(data);
  }

  Future<List<OrderSummary>> fetchMyOrders() async {
    final data = await _client.getJson('/pedidos/meus-pedidos/todos');
    return _parseOrderList(data);
  }

  Future<List<OrderSummary>> fetchRestaurantActiveOrders(
    int restaurantId,
  ) async {
    final data = await _client.getJson(
      '/pedidos/restaurante/$restaurantId/ativos',
    );
    return _parseOrderList(data);
  }

  Future<List<OrderSummary>> fetchRestaurantOrders(int restaurantId) async {
    final data = await _client.getJson(
      '/pedidos/restaurante/$restaurantId/todos',
    );
    return _parseOrderList(data);
  }

  Future<OrderSummary> updateStatus(int id, OrderStatus status) async {
    final data = await _client.patchJson('/pedidos/$id/status', {
      'status': status.apiValue,
    });
    if (data is Map) {
      return OrderSummary.fromJson(Map<String, dynamic>.from(data));
    }
    return fetchOrder(id);
  }

  List<OrderSummary> _parseOrderList(dynamic data) {
    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => OrderSummary.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    throw ApiClientException('Resposta inesperada ao listar pedidos.');
  }
}
