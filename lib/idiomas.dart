import 'dart:ui' as ui;

class Traductor {
  static String _idiomaActual = 'es';

  static final Map<String, Map<String, String>> _diccionario = {
    'es': {
      'titulo_app': 'El Mundo de Alegría',
      'importar_dibujos': 'Importar Dibujos',
      'borrar_pack': '¿Borrar este pack?',
      'borrar_aviso': 'Esta acción no se puede deshacer.',
      'cancelar': 'Cancelar',
      'si_borrar': 'Sí, borrar',
      'dibujos': 'dibujos',
      'caja_herramientas': 'Caja de Herramientas',
      'pintura': 'Pintura',
      'pincel': 'Pincel',
      'marcador': 'Marcador',
      'borrador': 'Borrador',
      'cerrar': 'Cerrar',
      'compartir_texto':
          '¡Mira mi obra de arte creada en El Mundo de Alegría! 🎨✨ Descárgala en Google Play.',
    },
    'en': {
      // Inglés (Mercado Global)
      'titulo_app': 'World of Joy',
      'importar_dibujos': 'Import Drawings',
      'borrar_pack': 'Delete this pack?',
      'borrar_aviso': 'This action cannot be undone.',
      'cancelar': 'Cancel',
      'si_borrar': 'Yes, delete',
      'dibujos': 'drawings',
      'caja_herramientas': 'Toolbox',
      'pintura': 'Paint',
      'pincel': 'Brush',
      'marcador': 'Marker',
      'borrador': 'Eraser',
      'cerrar': 'Close',
      'compartir_texto':
          'Look at my artwork created in World of Joy! 🎨✨ Get it on Google Play.',
    },
    'pt': {
      // Portugués (Brasil)
      'titulo_app': 'O Mundo da Alegria',
      'importar_dibujos': 'Importar Desenhos',
      'borrar_pack': 'Apagar este pacote?',
      'borrar_aviso': 'Esta ação não pode ser desfeita.',
      'cancelar': 'Cancelar',
      'si_borrar': 'Sim, apagar',
      'dibujos': 'desenhos',
      'caja_herramientas': 'Caixa de Ferramentas',
      'pintura': 'Pintura',
      'pincel': 'Pincel',
      'marcador': 'Marcador',
      'borrador': 'Borracha',
      'cerrar': 'Fechar',
      'compartir_texto':
          'Olha a minha obra de arte criada no O Mundo da Alegria! 🎨✨ Baixe no Google Play.',
    },
    'de': {
      // Alemán (Alemania, Suiza, Austria)
      'titulo_app': 'Die Welt der Freude',
      'importar_dibujos': 'Bilder importieren',
      'borrar_pack': 'Dieses Paket löschen?',
      'borrar_aviso': 'Diese Aktion kann nicht rückgängig gemacht werden.',
      'cancelar': 'Abbrechen',
      'si_borrar': 'Ja, löschen',
      'dibujos': 'Bilder',
      'caja_herramientas': 'Werkzeugkasten',
      'pintura': 'Malen',
      'pincel': 'Pinsel',
      'marcador': 'Marker',
      'borrador': 'Radiergummi',
      'cerrar': 'Schließen',
      'compartir_texto':
          'Schau dir mein Kunstwerk aus Die Welt der Freude an! 🎨✨',
    },
    'fr': {
      // Francés (Francia, Canadá, Bélgica)
      'titulo_app': 'Le Monde de la Joie',
      'importar_dibujos': 'Importer des dessins',
      'borrar_pack': 'Supprimer ce pack?',
      'borrar_aviso': 'Cette action est irréversible.',
      'cancelar': 'Annuler',
      'si_borrar': 'Oui, supprimer',
      'dibujos': 'dessins',
      'caja_herramientas': 'Boîte à outils',
      'pintura': 'Peinture',
      'pincel': 'Pinceau',
      'marcador': 'Marqueur',
      'borrador': 'Gomme',
      'cerrar': 'Fermer',
      'compartir_texto':
          'Regarde mon œuvre créée dans Le Monde de la Joie ! 🎨✨',
    }
  };

  static void inicializar() {
    final String idiomaDispositivo =
        ui.PlatformDispatcher.instance.locale.languageCode;
    if (_diccionario.containsKey(idiomaDispositivo)) {
      _idiomaActual = idiomaDispositivo;
    } else {
      _idiomaActual = 'en';
    }
  }

  static String get(String clave) {
    return _diccionario[_idiomaActual]?[clave] ?? clave;
  }
}
