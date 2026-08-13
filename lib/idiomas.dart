import 'dart:ui' as ui;

class Traductor {
  // Obtiene el código del idioma actual del teléfono (ej: 'es', 'en', 'pt')
  static String get idiomaActual {
    return ui.PlatformDispatcher.instance.locale.languageCode;
  }

  // Diccionario central con los idiomas principales
  static final Map<String, Map<String, String>> _diccionario = {
    'es': {
      'borrar_pack': 'Eliminar Colección',
      'borrar_aviso': '¿Seguro que quieres borrar estos dibujos?',
      'cancelar': 'Cancelar',
      'si_borrar': 'Sí, borrar',
      'zona_padres': 'Zona de Padres',
      'pide_ayuda':
          'Pide ayuda a un adulto.\nPara continuar, resuelve la suma:',
      'respuesta': 'Respuesta',
      'comprobar': 'Comprobar',
      'respuesta_incorrecta': 'Respuesta incorrecta.',
      'ajustes_premium': 'Ajustes Premium',
      'restaurar_compras': 'Restaurar Compras',
      'si_cambiaste': 'Si cambiaste de celular',
      'politica_privacidad': 'Política de Privacidad',
      'restaurando': 'Restaurando compras conectando a Google Play...',
    },
    'en': {
      'borrar_pack': 'Delete Collection',
      'borrar_aviso': 'Are you sure you want to delete these drawings?',
      'cancelar': 'Cancel',
      'si_borrar': 'Yes, delete',
      'zona_padres': 'Parents Zone',
      'pide_ayuda':
          'Ask an adult for help.\nTo continue, solve the math problem:',
      'respuesta': 'Answer',
      'comprobar': 'Check',
      'respuesta_incorrecta': 'Incorrect answer.',
      'ajustes_premium': 'Premium Settings',
      'restaurar_compras': 'Restore Purchases',
      'si_cambiaste': 'If you changed devices',
      'politica_privacidad': 'Privacy Policy',
      'restaurando': 'Restoring purchases connecting to Google Play...',
    },
    'pt': {
      'borrar_pack': 'Excluir Coleção',
      'borrar_aviso': 'Tem certeza de que deseja excluir estes desenhos?',
      'cancelar': 'Cancelar',
      'si_borrar': 'Sim, excluir',
      'zona_padres': 'Área para Pais',
      'pide_ayuda': 'Peça ajuda a um adulto.\nPara continuar, resolva a conta:',
      'respuesta': 'Resposta',
      'comprobar': 'Verificar',
      'respuesta_incorrecta': 'Resposta incorreta.',
      'ajustes_premium': 'Configurações Premium',
      'restaurar_compras': 'Restaurar Compras',
      'si_cambiaste': 'Se você trocou de celular',
      'politica_privacidad': 'Política de Privacidade',
      'restaurando': 'Restaurando compras conectando ao Google Play...',
    }
  };

  // Función que se llama desde la interfaz para obtener el texto correcto
  static String get(String clave) {
    String lang = idiomaActual;

    // Si el idioma del celular NO es Español ni Portugués, forzamos a Inglés (Ideal para India, Europa, Asia, etc.)
    if (lang != 'es' && lang != 'pt') {
      lang = 'en';
    }

    return _diccionario[lang]?[clave] ?? clave;
  }
}
