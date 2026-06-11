import 'package:flutter/foundation.dart';

import '../../../nucleo/configuracao/app_config.dart';
import '../dominio/cart_item.dart';
import '../dominio/product.dart';

enum FulfillmentMode { delivery, local }

class CartController extends ChangeNotifier {
  final Map<int, CartItem> _items = {};

  FulfillmentMode mode = FulfillmentMode.delivery;
  double deliveryFee = 6;
  double discount = 0;

  List<CartItem> get items => _items.values.toList(growable: false);
  bool get isEmpty => _items.isEmpty;
  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get total =>
      subtotal +
      (mode == FulfillmentMode.delivery ? deliveryFee : 0) -
      discount;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  int get restaurantId {
    for (final item in items) {
      final id = item.product.restaurantId;
      if (id != null && id > 0) return id;
    }
    return AppConfig.defaultRestaurantId;
  }

  void setMode(FulfillmentMode value) {
    mode = value;
    notifyListeners();
  }

  void add(Product product) {
    if (!product.available) return;
    final current = _items[product.id];
    _items[product.id] = current == null
        ? CartItem(product: product, quantity: 1)
        : current.copyWith(quantity: current.quantity + 1);
    notifyListeners();
  }

  void decrement(Product product) {
    final current = _items[product.id];
    if (current == null) return;
    if (current.quantity <= 1) {
      _items.remove(product.id);
    } else {
      _items[product.id] = current.copyWith(quantity: current.quantity - 1);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  Map<String, dynamic> toPedidoRequest({required String observacao}) {
    return {
      'restauranteId': restaurantId,
      'itens': items
          .map(
            (item) => {
              'produtoId': item.product.id,
              'quantidade': item.quantity,
            },
          )
          .toList(),
      'observacao': observacao,
      'tipoEntrega': mode == FulfillmentMode.delivery
          ? 'ENTREGA'
          : 'RETIRADA_NO_LOCAL',
    };
  }
}
