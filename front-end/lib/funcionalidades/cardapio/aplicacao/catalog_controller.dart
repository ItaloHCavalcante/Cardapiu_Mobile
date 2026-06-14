import 'package:flutter/foundation.dart';

import '../dados/menu_repository.dart';
import '../dominio/product.dart';
import '../dominio/restaurant.dart';

class CatalogController extends ChangeNotifier {
  CatalogController(this._repository);

  final MenuRepository _repository;

  bool isLoading = false;
  String? error;
  List<Restaurant> restaurants = const [];
  List<Product> products = const [];
  Restaurant? selectedRestaurant;

  Future<void> loadRestaurants() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      restaurants = await _repository.fetchRestaurants();
    } catch (exception) {
      error = exception.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadProducts(Restaurant restaurant) async {
    selectedRestaurant = restaurant;
    isLoading = true;
    products = const [];
    error = null;
    notifyListeners();

    try {
      products = await _repository.fetchProducts(restaurant.id);
    } catch (exception) {
      error = exception.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
