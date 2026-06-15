import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../../aplicativo/providers.dart';
import '../../../nucleo/utilitarios/currency.dart';
import '../../rastreamento/dominio/delivery_location.dart';
import '../../rastreamento/apresentacao/live_delivery_map.dart';
import '../dominio/order_summary.dart';

class OrderTrackingPage extends ConsumerStatefulWidget {
  const OrderTrackingPage({
    super.key,
    required this.orderId,
    this.initialOrder,
  });

  final int orderId;
  final OrderSummary? initialOrder;

  @override
  ConsumerState<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends ConsumerState<OrderTrackingPage> {
  OrderSummary? _order;
  bool _isLoading = false;
  String? _error;
  final List<LatLng> _history = [];

  @override
  void initState() {
    super.initState();
    _order = widget.initialOrder;
    Future.microtask(_refresh);
  }

  @override
  Widget build(BuildContext context) {
    final order = _order;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido #${widget.orderId}'),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _isLoading && order == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_error != null) ...[
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (order != null) ...[
                  _OrderStatusCard(order: order),
                  const SizedBox(height: 16),
                  _OrderDetailsCard(order: order),
                ],
                const SizedBox(height: 16),
                if (order?.deliveryId == null)
                  const _TrackingEmptyState(
                    icon: Icons.hourglass_empty,
                    message: 'Entrega ainda nao vinculada ao pedido.',
                  )
                else if (!order!.status.canShowTracking)
                  _TrackingEmptyState(
                    icon: Icons.schedule_outlined,
                    message: order.status.customerMessage,
                  )
                else
                  _LiveTrackingSection(
                    deliveryId: order.deliveryId!,
                    history: _history,
                  ),
              ],
            ),
    );
  }

  Future<void> _refresh() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      _order = await ref
          .read(orderRepositoryProvider)
          .fetchOrder(widget.orderId);
    } catch (exception) {
      _error = exception.toString();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

class _OrderStatusCard extends StatelessWidget {
  const _OrderStatusCard({required this.order});

  final OrderSummary order;

  @override
  Widget build(BuildContext context) {
    final createdAt = order.createdAt == null
        ? null
        : DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt!);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    order.status.label,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Chip(label: Text(money(order.total))),
              ],
            ),
            const SizedBox(height: 8),
            Text(order.status.customerMessage),
            if (createdAt != null) ...[
              const SizedBox(height: 6),
              Text('Criado em $createdAt'),
            ],
            if (order.deliveryId != null) ...[
              const SizedBox(height: 6),
              Text('Entrega #${order.deliveryId}'),
            ],
          ],
        ),
      ),
    );
  }
}

class _OrderDetailsCard extends StatelessWidget {
  const _OrderDetailsCard({required this.order});

  final OrderSummary order;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Itens do pedido',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(),
            ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text('${item.quantity}x'),
                      const SizedBox(width: 8),
                      Expanded(child: Text(item.productName)),
                      Text(money(item.unitPrice)),
                    ],
                  ),
                )),
            const Divider(),
            if (order.observation != null && order.observation!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Observação:',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(order.observation!),
            ],
          ],
        ),
      ),
    );
  }
}

class _LiveTrackingSection extends ConsumerWidget {
  const _LiveTrackingSection({required this.deliveryId, required this.history});

  final int deliveryId;
  final List<LatLng> history;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref
        .read(trackingRepositoryProvider)
        .watchDelivery(deliveryId);

    return StreamBuilder<DeliveryLocation?>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _TrackingEmptyState(
            icon: Icons.cloud_off_outlined,
            message: snapshot.error.toString(),
          );
        }

        final location = snapshot.data;
        if (location == null) {
          return const _TrackingEmptyState(
            icon: Icons.location_searching,
            message: 'Aguardando primeira localizacao do entregador.',
          );
        }

        if (history.isEmpty || history.last != location.point) {
          history.add(location.point);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LiveDeliveryMap(location: location, history: history),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Latitude: ${location.latitude.toStringAsFixed(6)}'),
                    Text('Longitude: ${location.longitude.toStringAsFixed(6)}'),
                    if (location.accuracy != null)
                      Text(
                        'Precisao: ${location.accuracy!.toStringAsFixed(1)} m',
                      ),
                    Text(
                      'Atualizado: ${DateFormat('HH:mm:ss').format(location.updatedAt.toLocal())}',
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TrackingEmptyState extends StatelessWidget {
  const _TrackingEmptyState({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(icon, size: 42),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
