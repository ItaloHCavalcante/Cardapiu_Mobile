import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../aplicativo/providers.dart';
import '../../../compartilhado/componentes/async_button.dart';
import '../dominio/user_role.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _senhaController = TextEditingController();
  final _placaController = TextEditingController();
  final _telefoneController = TextEditingController();
  UserRole _role = UserRole.user;
  bool _registerMode = false;

  @override
  void dispose() {
    _loginController.dispose();
    _senhaController.dispose();
    _placaController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.all(24),
              shrinkWrap: true,
              children: [
                Text(
                  'Cardapiu',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _registerMode ? 'Criar acesso' : 'Entrar no app',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _loginController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Login',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: _required,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _senhaController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        validator: _required,
                      ),
                      if (_registerMode) ...[
                        const SizedBox(height: 16),
                        SegmentedButton<UserRole>(
                          segments: UserRole.values
                              .where((role) => role != UserRole.deliverer)
                              .map(
                                (role) => ButtonSegment(
                                  value: role,
                                  label: Text(role.label),
                                  icon: Icon(_iconFor(role)),
                                ),
                              )
                              .toList(),
                          selected: {_role},
                          onSelectionChanged: (values) {
                            setState(() => _role = values.first);
                          },
                        ),
                      ],
                      // Removido campos de entregador já que não há suporte no momento
                      /* if (_registerMode && _role.isDeliverer) ...[
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _placaController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
                            labelText: 'Placa do veiculo',
                            prefixIcon: Icon(Icons.badge_outlined),
                          ),
                          validator: _required,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _telefoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Telefone',
                            prefixIcon: Icon(Icons.phone_outlined),
                          ),
                          validator: _required,
                        ),
                      ], */
                      if (session.error != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          session.error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      AsyncButton(
                        label: _registerMode ? 'Criar e entrar' : 'Entrar',
                        icon: _registerMode
                            ? Icons.person_add_alt
                            : Icons.login,
                        isBusy: session.isBusy,
                        onPressed: _submit,
                      ),
                      TextButton(
                        onPressed: session.isBusy
                            ? null
                            : () => setState(() {
                                  _registerMode = !_registerMode;
                                  if (_role.isDeliverer) {
                                    _role = UserRole.user;
                                  }
                                }),
                        child: Text(
                          _registerMode
                              ? 'Ja tenho uma conta'
                              : 'Criar uma nova conta',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconFor(UserRole role) => switch (role) {
    UserRole.user => Icons.shopping_bag_outlined,
    UserRole.admin => Icons.dashboard_outlined,
    UserRole.deliverer => Icons.delivery_dining,
  };

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Obrigatorio';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = ref.read(sessionControllerProvider);
    final login = _loginController.text.trim();
    final senha = _senhaController.text;

    if (_registerMode) {
      await controller.registerAndLogin(
        login: login,
        senha: senha,
        role: _role,
      );
    } else {
      await controller.login(login: login, senha: senha, selectedRole: _role);
    }
  }
}
