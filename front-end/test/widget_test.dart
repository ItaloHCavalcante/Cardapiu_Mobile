import 'package:cardapiu_mobile/aplicativo/cardapiu_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows login screen when no session exists', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: CardapiuApp()));
    await tester.pump();

    expect(find.text('Cardapiu'), findsOneWidget);
    expect(find.text('Entrar no app'), findsOneWidget);
  });
}
