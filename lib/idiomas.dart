import 'dart:ui' as ui;

class Traductor {
  static String _idiomaActual = 'es';
  static String get idiomaActual => _idiomaActual;

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
      'Stickers': 'Stickers',
      'cerrar': 'Cerrar',
      'onb_titulo_1': '¡Magia al Instante!',
      'onb_desc_1':
          'Toca cualquier espacio para llenarlo de color sin salirte de la raya.',
      'onb_titulo_2': 'Laboratorio de Colores',
      'onb_desc_2':
          'Aclara, oscurece o mezcla colores como un verdadero científico.',
      'onb_titulo_3': '¡Dibujos Infinitos!',
      'onb_desc_3':
          'Importa tus propias imágenes de la galería para pintarlas.',
      'onb_boton': '¡A Pintar! 🎨',
      'compartir_texto':
          '¡Mira mi obra de arte creada en El Mundo de Alegría! 🎨✨ Descárgala en Google Play.',
      'premium_titulo': '¡Desbloquea el Pase Mágico!',
      'premium_desc':
          'Obtén acceso ilimitado a todos los packs exclusivos y apoya el desarrollo de la app.',
      'premium_boton': '¡Desbloquear Todo!',
      'pack_bloqueado': 'Pack Premium',
    },
    'en': {
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
      'Stickers': 'Stickers',
      'cerrar': 'Close',
      'onb_titulo_1': 'Instant Magic!',
      'onb_desc_1':
          'Tap any space to fill it with color without going over the lines.',
      'onb_titulo_2': 'Color Laboratory',
      'onb_desc_2': 'Lighten, darken or mix colors like a real scientist.',
      'onb_titulo_3': 'Infinite Drawings!',
      'onb_desc_3': 'Import your own images from the gallery to paint them.',
      'onb_boton': 'Let\'s Paint! 🎨',
      'compartir_texto':
          'Look at my artwork created in World of Joy! 🎨✨ Get it on Google Play.',
      'premium_titulo': 'Unlock Magic Pass!',
      'premium_desc':
          'Get unlimited access to all exclusive packs and support app development.',
      'premium_boton': 'Unlock Everything!',
      'pack_bloqueado': 'Premium Pack',
    },
    'pt': {
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
      'Stickers': 'Adesivos',
      'cerrar': 'Fechar',
      'onb_titulo_1': 'Magia Instantânea!',
      'onb_desc_1':
          'Toque em qualquer espaço para preenchê-lo com cor sem sair da linha.',
      'onb_titulo_2': 'Laboratório de Cores',
      'onb_desc_2':
          'Clareie, escureça ou misture cores como um verdadeiro cientista.',
      'onb_titulo_3': 'Desenhos Infinitos!',
      'onb_desc_3': 'Importe suas próprias imagens da galeria para pintá-las.',
      'onb_boton': 'Vamos Pintar! 🎨',
      'compartir_texto':
          'Olha a minha obra de arte criada no O Mundo da Alegria! 🎨✨ Baixe no Google Play.',
      'premium_titulo': 'Desbloquear Passe Mágico!',
      'premium_desc': 'Tenha acesso ilimitado a todos os pacotes exclusivos.',
      'premium_boton': 'Desbloquear Tudo!',
      'pack_bloqueado': 'Pacote Premium',
    },
    'de': {
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
      'Stickers': 'Sticker',
      'cerrar': 'Schließen',
      'onb_titulo_1': 'Sofortige Magie!',
      'onb_desc_1':
          'Tippe auf einen Bereich, um ihn mit Farbe zu füllen, ohne über die Linien zu malen.',
      'onb_titulo_2': 'Farblabor',
      'onb_desc_2':
          'Helle Farben auf, verdunkle oder mische sie wie ein echter Wissenschaftler.',
      'onb_titulo_3': 'Unendliche Bilder!',
      'onb_desc_3':
          'Importiere deine eigenen Bilder aus der Galerie, um sie auszumalen.',
      'onb_boton': 'Lass uns malen! 🎨',
      'compartir_texto':
          'Schau dir mein Kunstwerk aus Die Welt der Freude an! 🎨✨',
      'premium_titulo': 'Magischen Pass freischalten!',
      'premium_desc':
          'Erhalte unbegrenzten Zugriff auf alle exklusiven Pakete.',
      'premium_boton': 'Alles freischalten!',
      'pack_bloqueado': 'Premium-Paket',
    },
    'fr': {
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
      'Stickers': 'Autocollants',
      'cerrar': 'Fermer',
      'onb_titulo_1': 'Magie Instantanée !',
      'onb_desc_1':
          'Touche n\'importe quel espace pour le remplir de couleur sans dépasser les lignes.',
      'onb_titulo_2': 'Laboratoire de Couleurs',
      'onb_desc_2':
          'Éclaircis, assombris ou mélange les couleurs comme un vrai scientifique.',
      'onb_titulo_3': 'Dessins Infinis !',
      'onb_desc_3':
          'Importe tes propres images de la galerie pour les peindre.',
      'onb_boton': 'Allons Peindre ! 🎨',
      'compartir_texto':
          'Regarde mon œuvre créée dans Le Monde de la Joie ! 🎨✨',
      'premium_titulo': 'Débloquer le Pass Magique !',
      'premium_desc': 'Obtenez un accès illimité à tous les packs exclusifs.',
      'premium_boton': 'Tout débloquer !',
      'pack_bloqueado': 'Pack Premium',
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

  static void setIdioma(String lang) {
    if (_diccionario.containsKey(lang)) {
      _idiomaActual = lang;
    }
  }

  static String get(String clave) {
    return _diccionario[_idiomaActual]?[clave] ?? clave;
  }
}
