import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_projects/main.dart';

void main() {
  testWidgets('UniSphere app loads welcome screen', (WidgetTester tester) async {
    await tester.pumpWidget(const UniSphereApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('UNISPHERE'), findsOneWidget);
  });
}
