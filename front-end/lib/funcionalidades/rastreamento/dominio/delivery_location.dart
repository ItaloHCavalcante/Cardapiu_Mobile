import 'package:latlong2/latlong.dart';

class DeliveryLocation {
  const DeliveryLocation({
    required this.latitude,
    required this.longitude,
    required this.updatedAt,
    this.accuracy,
    this.speed,
    this.heading,
    this.delivererId,
    this.status,
  });

  final double latitude;
  final double longitude;
  final DateTime updatedAt;
  final double? accuracy;
  final double? speed;
  final double? heading;
  final String? delivererId;
  final String? status;

  LatLng get point => LatLng(latitude, longitude);

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'accuracy': accuracy,
    'speed': speed,
    'heading': heading,
    'delivererId': delivererId,
    'status': status,
    'updatedAt': updatedAt.toUtc().toIso8601String(),
  };

  factory DeliveryLocation.fromJson(Map<String, dynamic> json) {
    return DeliveryLocation(
      latitude: _asDouble(json['latitude']),
      longitude: _asDouble(json['longitude']),
      updatedAt:
          DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
      accuracy: _nullableDouble(json['accuracy']),
      speed: _nullableDouble(json['speed']),
      heading: _nullableDouble(json['heading']),
      delivererId: json['delivererId']?.toString(),
      status: json['status']?.toString(),
    );
  }

  static double _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().replaceAll(',', '.')) ?? 0;
  }

  static double? _nullableDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().replaceAll(',', '.'));
  }
}
