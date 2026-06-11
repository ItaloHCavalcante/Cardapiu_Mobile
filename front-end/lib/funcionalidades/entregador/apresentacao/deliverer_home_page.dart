import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../aplicativo/providers.dart';
import '../../../compartilhado/componentes/async_button.dart';
import '../../pedidos/dominio/order_status.dart';

class DelivererHomePage extends ConsumerStatefulWidget {
  const DelivererHomePage({super.key});

  @override
  ConsumerState<DelivererHomePage> createState() => _DelivererHomePageState();
}

class _DelivererHomePageState extends ConsumerState<DelivererHomePage> {
  final _deliveryId = TextEditingController();
  final _delivererId = TextEditingController();
  final _pedidoId = TextEditingController();
  final _placa = TextEditingController();
  final _telefone = TextEditingController();
  final _usuarioId = TextEditingController();
  OrderStatus _trackingStatus = OrderStatus.saiuParaEntrega;
  bool _profileBusy = false;
  bool _statusBusy = false;

  @override
  void initState() {
    super.initState();
    final login = ref.read(sessionControllerProvider).session?.login;
    if (login != null) {
      _delivererId.text = login;
    }
  }

  @override
  void dispose() {
    _deliveryId.dispose();
    _delivererId.dispose();
    _pedidoId.dispose();
    _placa.dispose();
    _telefone.dispose();
    _usuarioId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tracking = ref.watch(trackingControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entregador'),
        actions: [
          IconButton(
            tooltip: 'Sair',
            onPressed: () => ref.read(sessionControllerProvider).logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Perfil de entrega',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _placa,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(labelText: 'Placa'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _telefone,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Telefone'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _usuarioId,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'ID do usuario',
                    ),
                  ),
                  const SizedBox(height: 12),
                  AsyncButton(
                    label: 'Salvar perfil',
                    icon: Icons.badge_outlined,
                    isBusy: _profileBusy,
                    onPressed: _createProfile,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Rastreamento em tempo real',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _deliveryId,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'ID da entrega',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _delivererId,
                    decoration: const InputDecoration(
                      labelText: 'Identificador',
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<OrderStatus>(
                    initialValue: _trackingStatus,
                    decoration: const InputDecoration(
                      labelText: 'Status enviado',
                    ),
                    items:
                        const [
                              OrderStatus.aguardandoColeta,
                              OrderStatus.saiuParaEntrega,
                              OrderStatus.emTransito,
                            ]
                            .map(
                              (status) => DropdownMenuItem(
                                value: status,
                                child: Text(status.label),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _trackingStatus = value);
                      }
                    },
                  ),
                  if (tracking.error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      tracking.error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  AsyncButton(
                    label: tracking.isPublishing
                        ? 'Rastreamento ativo'
                        : 'Iniciar GPS',
                    icon: Icons.my_location,
                    isBusy: tracking.isBusy,
                    onPressed: tracking.isPublishing ? null : _startTracking,
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: tracking.isPublishing && !tracking.isBusy
                        ? _stopTracking
                        : null,
                    icon: const Icon(Icons.stop_circle_outlined),
                    label: const Text('Parar rastreamento'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Atualizar pedido',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _pedidoId,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'ID do pedido',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton.tonalIcon(
                        onPressed: _statusBusy
                            ? null
                            : () => _patchStatus(OrderStatus.saiuParaEntrega),
                        icon: const Icon(Icons.inventory_2_outlined),
                        label: const Text('Confirmar coleta'),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: _statusBusy
                            ? null
                            : () => _patchStatus(OrderStatus.entregue),
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Confirmar entrega'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _statusBusy
                            ? null
                            : () => _patchStatus(OrderStatus.cancelado),
                        icon: const Icon(Icons.cancel_outlined),
                        label: const Text('Cancelar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createProfile() async {
    final usuarioId = int.tryParse(_usuarioId.text.trim());
    if (_placa.text.trim().isEmpty ||
        _telefone.text.trim().isEmpty ||
        usuarioId == null) {
      _snack('Informe placa, telefone e ID do usuario.');
      return;
    }

    setState(() => _profileBusy = true);
    try {
      await ref
          .read(delivererRepositoryProvider)
          .createProfile(
            placaVeiculo: _placa.text.trim().toUpperCase(),
            telefone: _telefone.text.trim(),
            usuarioId: usuarioId,
          );
      _snack('Perfil salvo.');
    } catch (exception) {
      _snack(exception.toString());
    } finally {
      if (mounted) setState(() => _profileBusy = false);
    }
  }

  Future<void> _startTracking() async {
    final deliveryId = int.tryParse(_deliveryId.text.trim());
    if (deliveryId == null || _delivererId.text.trim().isEmpty) {
      _snack('Informe ID da entrega e identificador.');
      return;
    }

    await ref
        .read(trackingControllerProvider)
        .startPublishing(
          deliveryId: deliveryId,
          delivererId: _delivererId.text.trim(),
          status: _trackingStatus,
        );
  }

  Future<void> _stopTracking() {
    return ref.read(trackingControllerProvider).stopPublishing();
  }

  Future<void> _patchStatus(OrderStatus status) async {
    final pedidoId = int.tryParse(_pedidoId.text.trim());
    if (pedidoId == null) {
      _snack('Informe o ID do pedido.');
      return;
    }

    setState(() => _statusBusy = true);
    try {
      await ref.read(orderRepositoryProvider).updateStatus(pedidoId, status);
      _snack('Pedido atualizado para ${status.label}.');
    } catch (exception) {
      _snack(exception.toString());
    } finally {
      if (mounted) setState(() => _statusBusy = false);
    }
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
