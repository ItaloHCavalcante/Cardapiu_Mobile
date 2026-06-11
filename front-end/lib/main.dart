import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'aplicativo/cardapiu_app.dart';
import 'nucleo/configuracao/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (AppConfig.hasFirebaseConfig) {
    await Firebase.initializeApp(options: AppConfig.firebaseOptions);
  } else {
    debugPrint(
      'Firebase nao inicializado. Informe FIREBASE_* via --dart-define.',
    );
  }

  runApp(const ProviderScope(child: CardapiuApp()));
}
