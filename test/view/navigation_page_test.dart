import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helpmedecide/view/navigation_page.dart';

void main() {
  testWidgets("BottomNavigationBar exists", (widgetTester) async {
    await widgetTester.pumpWidget(const NavigationPage());

    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}
