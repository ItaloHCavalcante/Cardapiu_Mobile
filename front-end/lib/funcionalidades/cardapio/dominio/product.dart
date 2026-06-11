class Product {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.available,
    this.restaurantId,
    this.category,
  });

  final int id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final bool available;
  final int? restaurantId;
  final String? category;

  factory Product.fromJson(Map<String, dynamic> json) {
    final status = json['status']?.toString().toUpperCase();
    final active =
        json['ativo'] != false &&
        json['disponivel'] != false &&
        status != 'INATIVO' &&
        status != 'ESGOTADO';
    final restaurant = json['restaurante'];
    final category = json['categoria'];

    return Product(
      id: _asInt(json['id']),
      name: json['nome']?.toString() ?? 'Produto',
      description: json['descricao']?.toString() ?? '',
      price: _asDouble(json['preco']),
      imageUrl: json['urlImage']?.toString(),
      available: active,
      restaurantId: restaurant is Map ? _nullableInt(restaurant['id']) : null,
      category: category is Map ? category['nome']?.toString() : null,
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
