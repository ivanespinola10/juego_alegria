import 'dart:ui';

class Traductor {
  // Obtenemos el idioma del sistema operativo del celular ('es', 'en', etc.)
  static final String _codigoIdioma =
      PlatformDispatcher.instance.locale.languageCode;

  // Nuestro Diccionario Centralizado
  static final Map<String, Map<String, String>> _diccionario = {
    'es': {
      'pintar': 'Pintar',
      'sellos': 'Sellos',
      'salir': 'Salir',
      'limpiar': 'Limpiar',
      'deshacer': 'Deshacer',
      'anterior': 'Anterior',
      'siguiente': 'Siguiente',
      'visor_mezcla': 'VISOR DE MEZCLA',
      'color': 'Color',
      'gratis': 'GRATIS',
      'importar': 'Importar Dibujos',
      'libro_infinito': 'Libro Infinito',
      'desbloquea': 'Desbloquea la importación de carpetas.',
      'codigo_colegio': '¿Tienes un código de colegio?',
    },
    'en': {
      'pintar': 'Paint',
      'sellos': 'Stickers',
      'salir': 'Exit',
      'limpiar': 'Clear',
      'deshacer': 'Undo',
      'anterior': 'Previous',
      'siguiente': 'Next',
      'visor_mezcla': 'MIX VIEWER',
      'color': 'Color',
      'gratis': 'FREE',
      'importar': 'Import Drawings',
      'libro_infinito': 'Infinite Book',
      'desbloquea': 'Unlock unlimited folder imports.',
      'codigo_colegio': 'Do you have a school code?',
    }
  };

  // Función mágica que entrega la palabra correcta
  static String get(String clave) {
    // Si el celular está en español, usa 'es'. Para cualquier otro idioma (ej. alemán, japonés), usará inglés ('en') por defecto.
    String idiomaSeleccionado =
        _diccionario.containsKey(_codigoIdioma) ? _codigoIdioma : 'en';

    // Retorna la palabra traducida. Si no la encuentra, devuelve la clave original.
    return _diccionario[idiomaSeleccionado]?[clave] ?? clave;
  }
}
