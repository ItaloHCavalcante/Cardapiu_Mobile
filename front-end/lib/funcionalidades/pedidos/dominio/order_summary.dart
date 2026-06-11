import 'order_status.dart';

class OrderSummary {
  const OrderSummary({
    required this.id,
    required this.status,
    required this.total,
    required this.observation,
    required this.deliveryType,
    this.deliveryId,
    this.createdAt,
  });

  final int id;
  final OrderStatus status;
  final double total;
  final String? observation;
  final String? deliveryType;
  final int? deliveryId;
  final DateTime? createdAt;

  factory OrderSummary.fromJson(Map<String, dynamic> json) {
    return OrderSummary(
      id: _asInt(json['id']),
      status: OrderStatus.fromApi(json['status']?.toString()),
      total: _asDouble(json['valorTotal'] ?? json['total']),
      observation: json['observacao']?.toString(),
      deliveryType: json['tipoEntrega']?.toString(),
      deliveryId: _nullableInt(json['entregaId']),
      createdAt: DateTime.tryParse(json['dataCriacao']?.toString() ?? ''),
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  static int? _nullableInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static double _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().replaceAll(',', '.')) ?? 0;
  }
}
