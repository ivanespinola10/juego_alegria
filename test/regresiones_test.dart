import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/idiomas.dart';
import 'package:myapp/zona_adultos.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Every bundled page referenced by the menu exists', () {
    final source = File('lib/menu_principal.dart').readAsStringSync();
    final paths = RegExp(r'assets/[A-Za-z0-9_./-]+\.png')
        .allMatches(source)
        .map((m) => m.group(0)!)
        .toSet();
    expect(paths.length, 50);
    for (final path in paths) {
      expect(File(path).existsSync(), isTrue, reason: 'Missing $path');
    }
  });

  test('Language survives initialization and invalid choices', () async {
    SharedPreferences.setMockInitialValues({});
    await Traductor.setIdioma('fr');
    await Traductor.inicializar();
    expect(Traductor.idiomaActual, 'fr');
    await Traductor.setIdioma('invalid');
    expect(Traductor.idiomaActual, 'fr');
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('idioma'), 'fr');
  });

  testWidgets('Adult barrier rejects a blank answer and accepts the sum', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await Traductor.setIdioma('es');
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await solicitarAdulto(context);
            },
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextButton>(find.widgetWithText(TextButton, 'Continuar'))
          .onPressed,
      isNull,
    );
    final challenge = tester
        .widgetList<Text>(find.byType(Text))
        .map((t) => t.data ?? '')
        .firstWhere((s) => s.contains(' + '));
    final numbers = RegExp(r'\d+')
        .allMatches(challenge)
        .map((m) => int.parse(m.group(0)!))
        .toList();
    await tester.enterText(
      find.byType(TextField),
      '${numbers[0] + numbers[1]}',
    );
    await tester.pump();
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(result, isTrue);
  });

  testWidgets('Cancel adult barrier never authorizes action', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await Traductor.setIdioma('es');
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await solicitarAdulto(context);
            },
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(result, isFalse);
  });
}
