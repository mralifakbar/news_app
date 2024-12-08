import 'package:flutter_test/flutter_test.dart';
import 'package:open_mateo_api/open_mateo_api.dart';

void main() {
  group('Weather', () {
    group('fromJson', () {
      test('returns correct Weather object', () {
        expect(
          Weather.fromJson(
              <String, dynamic>{'temperature': 15.3, 'weathercode': 63}),
          isA<Weather>()
              .having((p0) => p0.temperature, 'temperature', 15.3)
              .having((p0) => p0.weatherCode, 'weatherCode', 63),
        );
      });
    });
  });
}
