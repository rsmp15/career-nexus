import 'package:flutter_test/flutter_test.dart';
import 'package:farmer_app_ui/main.dart';

void main() {
  testWidgets('FarmerApp builds successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const FarmerApp());
  });
}
