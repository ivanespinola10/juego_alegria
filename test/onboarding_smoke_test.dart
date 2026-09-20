import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/idiomas.dart';
import 'package:myapp/main.dart';

void main() {
  testWidgets('onboarding inicial carga sin errores', (tester) async {
    Traductor.setIdioma('es');

    await tester.pumpWidget(
      const AlegriaApp(mostrarOnboarding: true),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text(Traductor.get('onb_titulo_1')), findsOneWidget);
  });
}
