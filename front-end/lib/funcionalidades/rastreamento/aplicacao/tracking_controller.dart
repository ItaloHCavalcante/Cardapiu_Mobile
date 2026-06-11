import 'package:flutter/foundation.dart';

import '../../pedidos/dominio/order_status.dart';
import '../dados/location_publisher.dart';
import '../dados/tracking_repository.dart';

class TrackingController extends ChangeNotifier {
  TrackingController(this.repository, this._publisher);

  final TrackingRepository repository;
  final LocationPublisher _publisher;

  bool isBusy = false;
  String? error;

  bool get isPublishing => _publisher.isRunning;
  int? get activeDeliveryId => _publisher.activeDeliveryId;

  Future<void> startPublishing({
    required int deliveryId,
    required String delivererId,
    OrderStatus status = OrderStatus.saiuParaEntrega,
  }) async {
    await _run(() async {
      final allowed = await _publisher.ensurePermission(background: true);
      if (!allowed) {
        throw StateError('Permita localizacao em segundo plano para entregar.');
      }
      await _publisher.start(
        deliveryId: deliveryId,
        delivererId: delivererId,
        status: status,
      );
    });
  }

  Future<void> stopPublishing() async {
    await _run(_publisher.stop);
  }

  Future<void> _run(Future<void> Function() action) async {
    isBusy = true;
    error = null;
    notifyListeners();
    try {
      await action();
    } catch (exception) {
      error = exception.toString();
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }
}
