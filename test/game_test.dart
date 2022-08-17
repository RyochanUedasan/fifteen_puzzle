import 'package:fifteen_puzzle/play.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows initial score', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Play()));

    expect(find.text('Moves: 0'), findsOneWidget);
  });
}
