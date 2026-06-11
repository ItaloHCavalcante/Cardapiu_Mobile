import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../nucleo/configuracao/app_config.dart';
import '../dominio/delivery_location.dart';

class TrackingRepository {
  DatabaseReference _locationRef(int deliveryId) {
    if (Firebase.apps.isEmpty) {
      throw StateError('Firebase nao configurado para o rastreio.');
    }
    return FirebaseDatabase.instance.ref(
      '${AppConfig.firebaseDeliveryPath}/$deliveryId/localizacaoAtual',
    );
  }

  Stream<DeliveryLocation?> watchDelivery(int deliveryId) {
    return _locationRef(deliveryId).onValue.map((event) {
      final value = event.snapshot.value;
      if (value is! Map) return null;
      return DeliveryLocation.fromJson(
        value.map((key, mapValue) => MapEntry(key.toString(), mapValue)),
      );
    });
  }

  Future<void> publishLocation({
    required int deliveryId,
    required DeliveryLocation location,
  }) {
    return _locationRef(deliveryId).set(location.toJson());
  }

  Future<void> markOffline(int deliveryId) {
    return _locationRef(deliveryId).update({
      'online': false,
      'updatedAt': DateTime.now().toUtc().toIso8601String(),
    });
  }
}
