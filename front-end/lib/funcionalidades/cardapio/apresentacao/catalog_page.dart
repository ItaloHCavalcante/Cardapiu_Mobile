import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../aplicativo/providers.dart';
import '../../../nucleo/utilitarios/currency.dart';
import '../../../compartilhado/componentes/async_button.dart';
import '../../pedidos/apresentacao/order_tracking_page.dart';
import '../aplicacao/cart_controller.dart';
import '../dominio/product.dart';
import '../dominio/restaurant.dart';
import 'restaurant_details_page.dart';

class CatalogPage extends ConsumerStatefulWidget {
  const CatalogPage({super.key});

  @override
  ConsumerState<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends ConsumerState<CatalogPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(catalogControllerProvider).loadRestaurants());
  }

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(catalogControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurantes'),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            onPressed: () => ref.read(catalogControllerProvider).loadRestaurants(),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Sair',
            onPressed: () => ref.read(sessionControllerProvider).logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              onChanged: (value) => ref.read(catalogControllerProvider).setSearchQuery(value),
              decoration: const InputDecoration(
                hintText: 'Pesquisar restaurante...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(catalogControllerProvider).loadRestaurants(),
              child: catalog.isLoading && catalog.restaurants.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : catalog.error != null
                      ? _ErrorState(
                          message: catalog.error!,
                          onRetry: () => ref.read(catalogControllerProvider).loadRestaurants(),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: catalog.filteredRestaurants.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final restaurant = catalog.filteredRestaurants[index];
                            return _RestaurantCard(restaurant: restaurant);
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  const _RestaurantCard({required this.restaurant});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RestaurantDetailsPage(restaurant: restaurant),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (restaurant.imageUrl != null)
              Image.network(
                restaurant.imageUrl!,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(
                  height: 150,
                  child: Icon(Icons.restaurant, size: 48),
                ),
              )
            else
              const SizedBox(
                height: 150,
                child: Icon(Icons.restaurant, size: 48),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${restaurant.address}, ${restaurant.number}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Opacity(
      opacity: product.available ? 1 : 0.5,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox.square(
                  dimension: 84,
                  child: product.imageUrl == null || product.imageUrl!.isEmpty
                      ? ColoredBox(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          child: const Icon(Icons.fastfood_outlined),
                        )
                      : Image.network(
                          product.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              const Icon(Icons.fastfood_outlined),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Text(
                          money(product.price),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    if (product.category != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        product.category!,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                    if (product.description.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        product.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.icon(
                        onPressed: product.available
                            ? () =>
                                  ref.read(cartControllerProvider).add(product)
                            : null,
                        icon: const Icon(Icons.add_shopping_cart),
                        label: Text(
                          product.available ? 'Adicionar' : 'Indisponivel',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartBar extends ConsumerWidget {
  const CartBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartControllerProvider);

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xffe1e5df))),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${cart.itemCount} item(ns)'),
                  Text(
                    money(cart.total),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (_) => const _CheckoutSheet(),
              ),
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text('Carrinho'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckoutSheet extends ConsumerStatefulWidget {
  const _CheckoutSheet();

  @override
  ConsumerState<_CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends ConsumerState<_CheckoutSheet> {
  final _formKey = GlobalKey<FormState>();
  final _rua = TextEditingController();
  final _numero = TextEditingController();
  final _bairro = TextEditingController();
  final _retirada = TextEditingController();
  final _observacao = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _rua.dispose();
    _numero.dispose();
    _bairro.dispose();
    _retirada.dispose();
    _observacao.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartControllerProvider);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Carrinho',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Fechar',
                    onPressed: Navigator.of(context).pop,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...cart.items.map(
                (item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item.product.name),
                  subtitle: Text(
                    '${item.quantity} x ${money(item.product.price)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Remover',
                        onPressed: () => ref
                            .read(cartControllerProvider)
                            .decrement(item.product),
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                      ),
                      Text(money(item.total)),
                    ],
                  ),
                ),
              ),
              const Divider(),
              SegmentedButton<FulfillmentMode>(
                segments: const [
                  ButtonSegment(
                    value: FulfillmentMode.delivery,
                    label: Text('Delivery'),
                    icon: Icon(Icons.delivery_dining),
                  ),
                  ButtonSegment(
                    value: FulfillmentMode.local,
                    label: Text('Local'),
                    icon: Icon(Icons.storefront_outlined),
                  ),
                ],
                selected: {cart.mode},
                onSelectionChanged: (values) {
                  ref.read(cartControllerProvider).setMode(values.first);
                },
              ),
              const SizedBox(height: 12),
              if (cart.mode == FulfillmentMode.delivery) ...[
                TextFormField(
                  controller: _rua,
                  decoration: const InputDecoration(labelText: 'Rua'),
                  validator: _required,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _numero,
                        decoration: const InputDecoration(labelText: 'Numero'),
                        validator: _required,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _bairro,
                        decoration: const InputDecoration(labelText: 'Bairro'),
                        validator: _required,
                      ),
                    ),
                  ],
                ),
              ] else
                TextFormField(
                  controller: _retirada,
                  decoration: const InputDecoration(
                    labelText: 'Nome para retirada ou mesa',
                  ),
                  validator: _required,
                ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _observacao,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Observacao'),
              ),
              const SizedBox(height: 12),
              _TotalLine(label: 'Subtotal', value: cart.subtotal),
              _TotalLine(
                label: 'Taxa de entrega',
                value: cart.mode == FulfillmentMode.delivery
                    ? cart.deliveryFee
                    : 0,
              ),
              _TotalLine(label: 'Descontos', value: -cart.discount),
              const Divider(),
              _TotalLine(label: 'Total', value: cart.total, strong: true),
              const SizedBox(height: 16),
              AsyncButton(
                label: 'Enviar pedido',
                icon: Icons.send_outlined,
                isBusy: _isSubmitting,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Obrigatorio';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final cart = ref.read(cartControllerProvider);
    final modeText = cart.mode == FulfillmentMode.delivery
        ? 'Delivery: ${_rua.text}, ${_numero.text}, ${_bairro.text}'
        : 'Local: ${_retirada.text}';
    final observacao = [
      modeText,
      if (_observacao.text.trim().isNotEmpty) _observacao.text.trim(),
    ].join(' | ');

    try {
      final order = await ref
          .read(orderRepositoryProvider)
          .createOrder(cart.toPedidoRequest(observacao: observacao));
      ref.read(cartControllerProvider).clear();
      if (!mounted) return;
      Navigator.of(context).pop();
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              OrderTrackingPage(orderId: order.id, initialOrder: order),
        ),
      );
    } catch (exception) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(exception.toString())));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}

class _TotalLine extends StatelessWidget {
  const _TotalLine({
    required this.label,
    required this.value,
    this.strong = false,
  });

  final String label;
  final double value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final style = strong
        ? Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)
        : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(money(value), style: style),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Icon(Icons.error_outline, size: 42),
        const SizedBox(height: 12),
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text('Tentar novamente'),
        ),
      ],
    );
  }
}
