import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Renders a raised button', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ElevatedButton(onPressed: () {}, child: const Text('Click me')));

    // Verify if the button is displayed.
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Click me'), findsOneWidget);
  });
}