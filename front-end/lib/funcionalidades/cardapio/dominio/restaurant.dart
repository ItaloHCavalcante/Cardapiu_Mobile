class Restaurant {
  const Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.number,
    this.imageUrl,
  });

  final int id;
  final String name;
  final String address;
  final String number;
  final String? imageUrl;

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as int,
      name: json['nome'] as String,
      address: json['endereco'] as String? ?? 'Sem endereço',
      number: json['numero'] as String? ?? 'S/N',
      imageUrl: json['urlImage'] as String?,
    );
  }
}
