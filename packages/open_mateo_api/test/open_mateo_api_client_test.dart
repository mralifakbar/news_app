import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:open_mateo_api/open_mateo_api.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  group(
    "OpenMateoApiClient",
    () {
      late http.Client httpClient;
      late OpenMateoApiClient openMateoApiClient;

      setUpAll(() => registerFallbackValue(FakeUri()));

      setUp(() {
        httpClient = MockHttpClient();
        openMateoApiClient = OpenMateoApiClient(httpClient: httpClient);
      });

      group('constructor', () {
        test(
          'does not require an httpClient',
          () => expect(OpenMateoApiClient(), isNotNull),
        );
      });

      group('locationSearch', () {
        const query = 'mock-query';
        test('makes correct http request', () async {
          final response = MockResponse();
          when(() => response.statusCode).thenReturn(200);
          when(() => response.body).thenReturn('{}');
          when(() => httpClient.get(any())).thenAnswer((_) async => response);

          try {
            await openMateoApiClient.locationSearch(query);
          } catch (_) {}

          verify(
            () => httpClient.get(
              Uri.https(
                'geocoding-api.open-meteo.com',
                '/v1/search',
                {'name': query, 'count': '1'},
              ),
            ),
          ).called(1);
        });

        test('throws LocationRequestFailure on non-200 response', () async {
          final response = MockResponse();
          when(() => response.statusCode).thenReturn(400);
          when(() => httpClient.get(any())).thenAnswer((_) async => response);

          expect(
            () async => await openMateoApiClient.locationSearch(query),
            throwsA(isA<LocationRequestFailure>()),
          );
        });

        test('throws LocationNotFoundFailure on empty results', () async {
          final response = MockResponse();
          when(() => response.statusCode).thenReturn(200);
          when(() => response.body).thenReturn('{}');
          when(() => httpClient.get(any())).thenAnswer((_) async => response);

          await expectLater(
            () async => await openMateoApiClient.locationSearch(query),
            throwsA(isA<LocationNotFoundFailure>()),
          );
        });

        test('throws LocationNotFoundFailure on missing results', () async {
          final response = MockResponse();
          when(() => response.statusCode).thenReturn(200);
          when(() => response.body).thenReturn('{}');
          when(() => httpClient.get(any())).thenAnswer((_) async => response);

          await expectLater(
            () async => await openMateoApiClient.locationSearch(query),
            throwsA(isA<LocationNotFoundFailure>()),
          );
        });

        test('returns Location on successful response', () async {
          final response = MockResponse();
          when(() => response.statusCode).thenReturn(200);
          when(() => response.body).thenReturn(
            '{"results": [{"id": 1, "name": "mock-name", "latitude": 1.0, "longitude": 1.0}]}',
          );
          when(() => httpClient.get(any())).thenAnswer((_) async => response);

          final location = await openMateoApiClient.locationSearch(query);

          expect(
            location,
            isA<Location>()
                .having((l) => l.id, 'id', 1)
                .having((l) => l.name, 'name', 'mock-name')
                .having((l) => l.latitude, 'latitude', 1.0)
                .having((l) => l.longitude, 'longitude', 1.0),
          );
        });
      });

      group('getWeather', () {
        const latitude = 41.85003;
        const longitude = -87.6500;

        test('makes correct http request', () async {
          final response = MockResponse();
          when(() => response.statusCode).thenReturn(200);
          when(() => response.body).thenReturn('{}');
          when(() => httpClient.get(any())).thenAnswer((_) async => response);
          try {
            await openMateoApiClient.getWeather(
                latitude: latitude, longitude: longitude);
          } catch (_) {}
          verify(
            () => httpClient.get(
              Uri.https('api.open-meteo.com', 'v1/forecast', {
                'latitude': '$latitude',
                'longitude': '$longitude',
                'current_weather': 'true',
              }),
            ),
          ).called(1);
        });

        test('throws WeatherRequestFailure on non-200 response', () async {
          final response = MockResponse();
          when(() => response.statusCode).thenReturn(400);
          when(() => httpClient.get(any())).thenAnswer((_) async => response);
          expect(
            () async => openMateoApiClient.getWeather(
              latitude: latitude,
              longitude: longitude,
            ),
            throwsA(isA<WeatherRequestFailure>()),
          );
        });

        test('throws WeatherNotFoundFailure on empty response', () async {
          final response = MockResponse();
          when(() => response.statusCode).thenReturn(200);
          when(() => response.body).thenReturn('{}');
          when(() => httpClient.get(any())).thenAnswer((_) async => response);
          expect(
            () async => openMateoApiClient.getWeather(
              latitude: latitude,
              longitude: longitude,
            ),
            throwsA(isA<WeatherNotFoundFailure>()),
          );
        });

        test('returns Weather on successful response', () async {
          final response = MockResponse();
          when(() => response.statusCode).thenReturn(200);
          when(() => response.body).thenReturn(
            '{"current_weather": {"temperature": 15.3, "weathercode": 63}}',
          );
          when(() => httpClient.get(any())).thenAnswer((_) async => response);

          final weather = await openMateoApiClient.getWeather(
            latitude: latitude,
            longitude: longitude,
          );

          expect(
            weather,
            isA<Weather>()
                .having((w) => w.temperature, 'temperature', 15.3)
                .having((w) => w.weatherCode, 'weatherCode', 63),
          );
        });
      });
    },
  );
}
