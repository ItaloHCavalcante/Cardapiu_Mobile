import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../aplicativo/providers.dart';
import '../../../compartilhado/componentes/async_button.dart';
import '../../pedidos/dominio/order_status.dart';

class AdminHomePage extends ConsumerStatefulWidget {
  const AdminHomePage({super.key});

  @override
  ConsumerState<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends ConsumerState<AdminHomePage> {
  final _pedidoId = TextEditingController();
  final _nome = TextEditingController();
  final _descricao = TextEditingController();
  final _preco = TextEditingController();
  final _imagem = TextEditingController();
  final _categoriaId = TextEditingController();
  final _restauranteId = TextEditingController(text: '1');
  OrderStatus _status = OrderStatus.emPreparo;
  bool _statusBusy = false;
  bool _productBusy = false;

  @override
  void dispose() {
    _pedidoId.dispose();
    _nome.dispose();
    _descricao.dispose();
    _preco.dispose();
    _imagem.dispose();
    _categoriaId.dispose();
    _restauranteId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel'),
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
                    'Status do pedido',
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
                  const SizedBox(height: 8),
                  DropdownButtonFormField<OrderStatus>(
                    initialValue: _status,
                    decoration: const InputDecoration(labelText: 'Novo status'),
                    items: backendPatchStatuses
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status.label),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _status = value);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  AsyncButton(
                    label: 'Atualizar status',
                    icon: Icons.sync_alt,
                    isBusy: _statusBusy,
                    onPressed: _updateStatus,
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
                    'Novo produto',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nome,
                    decoration: const InputDecoration(labelText: 'Nome'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descricao,
                    decoration: const InputDecoration(labelText: 'Descricao'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _preco,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(labelText: 'Preco'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _imagem,
                    decoration: const InputDecoration(
                      labelText: 'URL da imagem',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _categoriaId,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'ID categoria',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _restauranteId,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'ID restaurante',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AsyncButton(
                    label: 'Criar produto',
                    icon: Icons.add_box_outlined,
                    isBusy: _productBusy,
                    onPressed: _createProduct,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateStatus() async {
    final id = int.tryParse(_pedidoId.text.trim());
    if (id == null) {
      _snack('Informe o ID do pedido.');
      return;
    }

    setState(() => _statusBusy = true);
    try {
      await ref.read(orderRepositoryProvider).updateStatus(id, _status);
      _snack('Status atualizado.');
    } catch (exception) {
      _snack(exception.toString());
    } finally {
      if (mounted) setState(() => _statusBusy = false);
    }
  }

  Future<void> _createProduct() async {
    final nome = _nome.text.trim();
    final preco = double.tryParse(_preco.text.trim().replaceAll(',', '.'));
    final restauranteId = int.tryParse(_restauranteId.text.trim());
    final categoriaId = int.tryParse(_categoriaId.text.trim());

    if (nome.isEmpty || preco == null || preco <= 0 || restauranteId == null) {
      _snack('Nome, preco maior que zero e restaurante sao obrigatorios.');
      return;
    }

    setState(() => _productBusy = true);
    try {
      await ref.read(apiClientProvider).postJson('/produtos', {
        'nome': nome,
        'descricao': _descricao.text.trim(),
        'preco': preco,
        'urlImage': _imagem.text.trim(),
        'categoriaId': categoriaId,
        'restauranteId': restauranteId,
      });
      _nome.clear();
      _descricao.clear();
      _preco.clear();
      _imagem.clear();
      _categoriaId.clear();
      _snack('Produto criado.');
    } catch (exception) {
      _snack(exception.toString());
    } finally {
      if (mounted) setState(() => _productBusy = false);
    }
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
