import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../nucleo/tema/app_theme.dart';
import '../funcionalidades/administrador/apresentacao/admin_home_page.dart';
import '../funcionalidades/autenticacao/apresentacao/login_page.dart';
import '../funcionalidades/entregador/apresentacao/deliverer_home_page.dart';
import '../funcionalidades/cardapio/apresentacao/catalog_page.dart';
import '../funcionalidades/pedidos/apresentacao/order_lookup_page.dart';
import 'providers.dart';

class CardapiuApp extends ConsumerStatefulWidget {
  const CardapiuApp({super.key});

  @override
  ConsumerState<CardapiuApp> createState() => _CardapiuAppState();
}

class _CardapiuAppState extends ConsumerState<CardapiuApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(sessionControllerProvider).restore());
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionControllerProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cardapiu',
      theme: AppTheme.light(),
      home: switch ((session.isBootstrapping, session.session?.role)) {
        (true, _) => const _SplashPage(),
        (false, null) => const LoginPage(),
        (false, final role) when role!.isAdmin => const AdminHomePage(),
        (false, final role) when role!.isDeliverer => const DelivererHomePage(),
        _ => const CustomerHomePage(),
      },
    );
  }
}

class _SplashPage extends StatelessWidget {
  const _SplashPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = const [CatalogPage(), OrderLookupPage()];

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu),
            label: 'Cardapio',
          ),
          NavigationDestination(
            icon: Icon(Icons.route_outlined),
            selectedIcon: Icon(Icons.route),
            label: 'Pedido',
          ),
        ],
      ),
    );
  }
}
