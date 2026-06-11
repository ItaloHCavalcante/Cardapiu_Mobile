import 'package:flutter/foundation.dart';

import '../dados/menu_repository.dart';
import '../dominio/product.dart';

class CatalogController extends ChangeNotifier {
  CatalogController(this._repository);

  final MenuRepository _repository;

  bool isLoading = false;
  bool hasLoaded = false;
  String? error;
  List<Product> products = const [];

  Future<void> load({bool force = false}) async {
    if (isLoading || (hasLoaded && !force)) return;
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      products = await _repository.fetchProducts();
      hasLoaded = true;
    } catch (exception) {
      error = exception.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
