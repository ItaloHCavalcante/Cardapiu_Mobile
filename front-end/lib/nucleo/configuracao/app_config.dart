import 'package:firebase_core/firebase_core.dart';

class AppConfig {
  const AppConfig._();

  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );

  static const defaultRestaurantId = int.fromEnvironment(
    'DEFAULT_RESTAURANT_ID',
    defaultValue: 1,
  );

  static const firebaseDeliveryPath = String.fromEnvironment(
    'FIREBASE_DELIVERY_PATH',
    defaultValue: 'entregas',
  );

  static const firebaseApiKey = String.fromEnvironment('FIREBASE_API_KEY');
  static const firebaseAppId = String.fromEnvironment('FIREBASE_APP_ID');
  static const firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
  );
  static const firebaseMessagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
  );
  static const firebaseDatabaseUrl = String.fromEnvironment(
    'FIREBASE_DATABASE_URL',
  );

  static bool get hasFirebaseConfig =>
      firebaseApiKey.isNotEmpty &&
      firebaseAppId.isNotEmpty &&
      firebaseProjectId.isNotEmpty &&
      firebaseMessagingSenderId.isNotEmpty &&
      firebaseDatabaseUrl.isNotEmpty;

  static FirebaseOptions get firebaseOptions => const FirebaseOptions(
    apiKey: firebaseApiKey,
    appId: firebaseAppId,
    messagingSenderId: firebaseMessagingSenderId,
    projectId: firebaseProjectId,
    databaseURL: firebaseDatabaseUrl,
  );
}
