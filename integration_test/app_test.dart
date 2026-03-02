import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fav_resto_app/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('End-to-End Test: SHOULD not returns crash WHEN the app opened', (tester) async {
    app.main();

    await tester.pump(const Duration(seconds: 3));

    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}
