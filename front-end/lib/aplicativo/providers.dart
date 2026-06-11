import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../nucleo/configuracao/app_config.dart';
import '../nucleo/rede/api_client.dart';
import '../funcionalidades/autenticacao/aplicacao/session_controller.dart';
import '../funcionalidades/autenticacao/dados/auth_repository.dart';
import '../funcionalidades/entregador/dados/deliverer_repository.dart';
import '../funcionalidades/cardapio/aplicacao/cart_controller.dart';
import '../funcionalidades/cardapio/aplicacao/catalog_controller.dart';
import '../funcionalidades/cardapio/dados/menu_repository.dart';
import '../funcionalidades/pedidos/dados/order_repository.dart';
import '../funcionalidades/rastreamento/aplicacao/tracking_controller.dart';
import '../funcionalidades/rastreamento/dados/location_publisher.dart';
import '../funcionalidades/rastreamento/dados/tracking_repository.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient(AppConfig.apiBaseUrl);
  ref.onDispose(client.close);
  return client;
});

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.read(apiClientProvider)),
);

final sessionControllerProvider = ChangeNotifierProvider<SessionController>(
  (ref) => SessionController(
    ref.read(authRepositoryProvider),
    ref.read(apiClientProvider),
  ),
);

final menuRepositoryProvider = Provider<MenuRepository>(
  (ref) => MenuRepository(ref.read(apiClientProvider)),
);

final catalogControllerProvider = ChangeNotifierProvider<CatalogController>(
  (ref) => CatalogController(ref.read(menuRepositoryProvider)),
);

final cartControllerProvider = ChangeNotifierProvider<CartController>(
  (ref) => CartController(),
);

final orderRepositoryProvider = Provider<OrderRepository>(
  (ref) => OrderRepository(ref.read(apiClientProvider)),
);

final trackingRepositoryProvider = Provider<TrackingRepository>(
  (ref) => TrackingRepository(),
);

final locationPublisherProvider = Provider<LocationPublisher>(
  (ref) => LocationPublisher(ref.read(trackingRepositoryProvider)),
);

final trackingControllerProvider = ChangeNotifierProvider<TrackingController>(
  (ref) => TrackingController(
    ref.read(trackingRepositoryProvider),
    ref.read(locationPublisherProvider),
  ),
);

final delivererRepositoryProvider = Provider<DelivererRepository>(
  (ref) => DelivererRepository(ref.read(apiClientProvider)),
);
