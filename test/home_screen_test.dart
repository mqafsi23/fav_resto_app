import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'restaurant_provider_test.mocks.dart';
import 'package:fav_resto_app/screen/home_screen.dart';
import 'package:fav_resto_app/service/preferences_helper.dart';
import 'package:fav_resto_app/service/restaurant_provider.dart';

void main() {
  testWidgets('SHOULD displays TextField on HomeScreen WHEN the app started', (WidgetTester tester) async {
    final mockClient = MockClient();
    const dummyResponse = '{"error": false, "message": "success", "count": 0, "restaurants": []}';
    
    when(mockClient.get(Uri.parse('https://restaurant-api.dicoding.dev/list')))
        .thenAnswer((_) async => http.Response(dummyResponse, 200));

    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => RestaurantProvider(client: mockClient)..fetchRestaurants()),
          ChangeNotifierProvider(create: (_) => PreferencesHelper(sharedPreferences: prefs)),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });
}