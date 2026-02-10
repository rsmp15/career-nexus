import 'package:agrisetu_ui/agrisetu_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('TractorCard displays information correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TractorCard(
            name: 'John Deere 5050',
            description: 'Powerful 50HP tractor',
            pricePerHour: '800',
            distance: '5km',
            onBookPressed: () {},
          ),
        ),
      ),
    );

    expect(find.text('John Deere 5050'), findsOneWidget);
    expect(find.text('₹800/hr'), findsOneWidget);
    expect(find.text('5km away'), findsOneWidget);
    expect(find.text('Book Now'), findsOneWidget);
  });
}
