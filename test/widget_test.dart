import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:padm/main.dart';
import 'package:padm/screens/role_selection_screen.dart';

void main() {
  testWidgets('Login: se vad conturile salvate', (WidgetTester tester) async {
    await tester.pumpWidget(const LogisticsApp());

    expect(find.text('Fresh Foods SRL'), findsOneWidget);
    expect(find.text('Fast Trans SRL'), findsOneWidget);
    expect(find.text('Ion Popescu'), findsOneWidget);
    expect(find.text('Creeaza cont nou'), findsOneWidget);
  });

  testWidgets('Login: contul conectat intra direct', (WidgetTester tester) async {
    await tester.pumpWidget(const LogisticsApp());

    await tester.tap(find.text('Fresh Foods SRL'));
    await tester.pumpAndSettle();

    expect(find.text('Salut, Fresh Foods SRL!\nRol: Customer'), findsOneWidget);
  });

  testWidgets('Login: contul deconectat cere parola', (WidgetTester tester) async {
    await tester.pumpWidget(const LogisticsApp());

    await tester.tap(find.text('Fast Trans SRL'));
    await tester.pumpAndSettle();

    expect(find.text('Parola'), findsOneWidget);
  });

  testWidgets('Login: butonul de inregistrare deschide alegerea rolului',
      (WidgetTester tester) async {
    await tester.pumpWidget(const LogisticsApp());

    await tester.tap(find.text('Creeaza cont nou'));
    await tester.pumpAndSettle();

    expect(find.text('Cine esti?'), findsOneWidget);
  });

  testWidgets('Alegerea rolului activeaza butonul', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RoleSelectionScreen()));

    FilledButton button() => tester.widget(find.byType(FilledButton));
    expect(button().onPressed, isNull);

    await tester.tap(find.text('Carrier'));
    await tester.pump();
    expect(button().onPressed, isNotNull);
  });
}
