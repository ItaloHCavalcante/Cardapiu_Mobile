class OrderItem {
  const OrderItem({
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  final String productName;
  final int quantity;
  final double unitPrice;

  double get totalPrice => quantity * unitPrice;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    String name = json['nomeProduto']?.toString() ?? '';
    if (name.isEmpty && json['produto'] != null) {
      name = json['produto']['nome']?.toString() ?? '';
    }
    return OrderItem(
      productName: name,
      quantity: (json['quantidade'] as num?)?.toInt() ?? 0,
      unitPrice: (json['precoUnitario'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
