import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../../pedidos/dominio/order_status.dart';
import '../dominio/delivery_location.dart';
import 'tracking_repository.dart';

class LocationPublisher {
  LocationPublisher(this._repository);

  final TrackingRepository _repository;
  StreamSubscription<Position>? _subscription;
  int? _activeDeliveryId;

  bool get isRunning => _subscription != null;
  int? get activeDeliveryId => _activeDeliveryId;

  Future<bool> ensurePermission({bool background = true}) async {
    if (!await Geolocator.isLocationServiceEnabled()) return false;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }

    if (background && permission != LocationPermission.always) {
      permission = await Geolocator.requestPermission();
    }

    return background
        ? permission == LocationPermission.always
        : permission == LocationPermission.always ||
              permission == LocationPermission.whileInUse;
  }

  Future<void> start({
    required int deliveryId,
    required String delivererId,
    OrderStatus status = OrderStatus.saiuParaEntrega,
  }) async {
    await stop();
    _activeDeliveryId = deliveryId;

    final firstPosition = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
      ),
    );
    await _repository.publishLocation(
      deliveryId: deliveryId,
      location: _fromPosition(firstPosition, delivererId, status),
    );

    _subscription =
        Geolocator.getPositionStream(
          locationSettings: AndroidSettings(
            accuracy: LocationAccuracy.bestForNavigation,
            distanceFilter: 8,
            intervalDuration: const Duration(seconds: 5),
            foregroundNotificationConfig: const ForegroundNotificationConfig(
              notificationTitle: 'Cardapiu em entrega',
              notificationText: 'Enviando localizacao do entregador.',
              notificationChannelName: 'Rastreamento de entrega',
              enableWakeLock: true,
              setOngoing: true,
            ),
          ),
        ).listen((position) {
          _repository.publishLocation(
            deliveryId: deliveryId,
            location: _fromPosition(position, delivererId, status),
          );
        });
  }

  Future<void> stop() async {
    final deliveryId = _activeDeliveryId;
    await _subscription?.cancel();
    _subscription = null;
    _activeDeliveryId = null;
    if (deliveryId != null) {
      await _repository.markOffline(deliveryId);
    }
  }

  DeliveryLocation _fromPosition(
    Position position,
    String delivererId,
    OrderStatus status,
  ) {
    return DeliveryLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      speed: position.speed,
      heading: position.heading,
      delivererId: delivererId,
      status: status.apiValue,
      updatedAt: DateTime.now(),
    );
  }
}
