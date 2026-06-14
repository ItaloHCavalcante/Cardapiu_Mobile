import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../aplicativo/providers.dart';
import '../../../nucleo/utilitarios/currency.dart';
import '../dominio/product.dart';
import '../dominio/restaurant.dart';
import 'catalog_page.dart'; // Reutilizar _ProductCard se possível ou mover para componente

class RestaurantDetailsPage extends ConsumerStatefulWidget {
  const RestaurantDetailsPage({super.key, required this.restaurant});

  final Restaurant restaurant;

  @override
  ConsumerState<RestaurantDetailsPage> createState() => _RestaurantDetailsPageState();
}

class _RestaurantDetailsPageState extends ConsumerState<RestaurantDetailsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(catalogControllerProvider).loadProducts(widget.restaurant));
  }

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(catalogControllerProvider);
    final cart = ref.watch(cartControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.restaurant.name)),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.restaurant.imageUrl != null)
                  Image.network(
                    widget.restaurant.imageUrl!,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox(
                      height: 200,
                      child: Icon(Icons.restaurant, size: 64),
                    ),
                  )
                else
                  const SizedBox(
                    height: 200,
                    child: Icon(Icons.restaurant, size: 64),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.restaurant.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.restaurant.address}, ${widget.restaurant.number}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
          if (catalog.isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (catalog.error != null)
            SliverFillRemaining(
              child: Center(child: Text(catalog.error!)),
            )
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, cart.isEmpty ? 16 : 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = catalog.products[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: ProductCard(product: product),
                    );
                  },
                  childCount: catalog.products.length,
                ),
              ),
            ),
        ],
      ),
      bottomSheet: cart.isEmpty ? null : const CartBar(),
    );
  }
}
