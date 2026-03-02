import 'package:fav_resto_app/service/notification_helper.dart'
    show NotificationHelper;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import 'package:fav_resto_app/service/restaurant_provider.dart';
import 'package:fav_resto_app/model/restaurant.dart';
import 'restaurant_provider_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late RestaurantProvider provider;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    provider = RestaurantProvider(client: mockClient);
  });

  group('Restaurant Provider Testing', () {
    test('SHOULD has initial state WHEN the app started (InitialState)', () {
      expect(provider.listState, isA<InitialState>());
    });

    test(
      'SHOULD returns restaurant list WHEN API data returned successfully',
      () async {
        final jsonResponse =
            '{"error": false, "message": "success", "count": 1, "restaurants": [{"id": "1", "name": "Kafe", "description": "Enak", "pictureId": "1", "city": "Jakarta", "rating": 5.0}]}';
        when(
          mockClient.get(Uri.parse('https://restaurant-api.dicoding.dev/list')),
        ).thenAnswer((_) async => http.Response(jsonResponse, 200));

        await provider.fetchRestaurants();

        expect(provider.listState, isA<SuccessState<List<Restaurant>>>());
      },
    );

    test(
      'SHOULD returns an error WHEN API data returned unsuccessfully',
      () async {
        when(
          mockClient.get(Uri.parse('https://restaurant-api.dicoding.dev/list')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        await provider.fetchRestaurants();

        expect(provider.listState, isA<ErrorState<List<Restaurant>>>());
      },
    );

    test(
      "SHOULD doesn't have an error WHEN NotificationHelper retrieves the data from API",
      () async {
        final helper = NotificationHelper();

        expect(() async => await helper.showNotification(), returnsNormally);
      },
    );
  });
}
