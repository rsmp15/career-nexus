import 'package:agrisetu_api/agrisetu_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Machine Model', () {
    test('fromJson creates correct object', () {
      final json = {
        'id': 1,
        'name': 'Tractor X',
        'description': 'Heavy duty',
        'price_per_hour': '500.00',
        'owner_name': 'John Doe',
        'location': {
          'type': 'Point',
          'coordinates': [77.20, 28.61],
        },
      };

      final machine = Machine.fromJson(json);
      expect(machine.id, 1);
      expect(machine.name, 'Tractor X');
      expect(machine.pricePerHour, '500.00');
    });
  });
}
