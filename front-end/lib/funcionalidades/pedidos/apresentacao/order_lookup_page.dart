import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../aplicativo/providers.dart';
import '../../../nucleo/utilitarios/currency.dart';
import '../../../compartilhado/componentes/async_button.dart';
import '../dominio/order_summary.dart';
import 'order_tracking_page.dart';

class OrderLookupPage extends ConsumerStatefulWidget {
  const OrderLookupPage({super.key});

  @override
  ConsumerState<OrderLookupPage> createState() => _OrderLookupPageState();
}

class _OrderLookupPageState extends ConsumerState<OrderLookupPage> {
  final _orderId = TextEditingController();
  bool _isLoading = false;
  late Future<List<OrderSummary>> _activeOrdersFuture;

  @override
  void initState() {
    super.initState();
    _activeOrdersFuture = _loadActiveOrders();
  }

  @override
  void dispose() {
    _orderId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acompanhar pedido')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Pedidos ativos',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(
                tooltip: 'Atualizar',
                onPressed: () {
                  setState(() => _activeOrdersFuture = _loadActiveOrders());
                },
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          FutureBuilder<List<OrderSummary>>(
            future: _activeOrdersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(snapshot.error.toString()),
                  ),
                );
              }

              final orders = snapshot.data ?? const [];
              if (orders.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Nenhum pedido ativo encontrado.'),
                  ),
                );
              }

              return Column(
                children: orders.map((order) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.receipt_long_outlined),
                      title: Text('Pedido #${order.id}'),
                      subtitle: Text(order.status.label),
                      trailing: Text(money(order.total)),
                      onTap: () => _openOrder(order.id, initialOrder: order),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<List<OrderSummary>> _loadActiveOrders() {
    return ref.read(orderRepositoryProvider).fetchMyActiveOrders();
  }

  Future<void> _lookup() async {
    final id = int.tryParse(_orderId.text.trim());
    if (id == null) return;
    setState(() => _isLoading = true);

    try {
      final order = await ref.read(orderRepositoryProvider).fetchOrder(id);
      await _openOrder(id, initialOrder: order);
    } catch (exception) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(exception.toString())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _openOrder(int id, {OrderSummary? initialOrder}) async {
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            OrderTrackingPage(orderId: id, initialOrder: initialOrder),
      ),
    );
  }
}
