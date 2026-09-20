import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/idiomas.dart';

void main() {
  group('Traductor', () {
    test('cambia entre idiomas soportados', () {
      Traductor.setIdioma('es');
      expect(Traductor.get('libro_infinito'), 'Libro Infinito');

      Traductor.setIdioma('en');
      expect(Traductor.get('libro_infinito'), 'Infinite Coloring Book');

      Traductor.setIdioma('pt');
      expect(Traductor.get('libro_infinito'), 'Livro Infinito');
    });

    test('ignora idiomas no soportados', () {
      Traductor.setIdioma('es');
      Traductor.setIdioma('xx');
      expect(Traductor.idiomaActual, 'es');
    });
  });
}
