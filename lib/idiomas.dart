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
          '¡Mira mi obra de arte creada en El Mundo de Alegría! 🎨 $playUrl',
      'premium_titulo': 'Desbloquea el Libro Infinito',
      'premium_desc':
          'Importa tus propios dibujos y crea una biblioteca que puede seguir creciendo. Una sola compra, sin suscripción.',
      'premium_boton': 'Desbloquear Libro Infinito',
      'pack_bloqueado': 'Pack Premium',
      'menu_seccion': 'Elige una aventura para colorear',
      'libro_infinito': 'Libro Infinito',
      'libro_infinito_desc': 'Tus propios dibujos, sin límites',
      'compra_unica': 'Compra única',
      'desbloqueado': 'Desbloqueado',
      'restaurar_compras': 'Restaurar compra',
      'restaurando_compras': 'Buscando tu compra anterior…',
      'solo_adultos': 'Zona para adultos',
      'pregunta_adulto':
          'Para continuar con esta acción, pide ayuda a un adulto y resuelve:',
      'respuesta': 'Respuesta',
      'respuesta_incorrecta': 'Respuesta incorrecta',
      'comprobar': 'Comprobar',
      'limpiar_titulo': '¿Empezar de nuevo?',
      'limpiar_desc': 'Se borrarán los trazos y stickers de este dibujo.',
      'limpiar': 'Limpiar',
      'compartir': 'Compartir',
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
          'Look at my artwork created in World of Joy! 🎨 $playUrl',
      'premium_titulo': 'Unlock the Infinite Coloring Book',
      'premium_desc':
          'Import your own drawings and build a coloring library that keeps growing. One purchase, no subscription.',
      'premium_boton': 'Unlock Infinite Book',
      'pack_bloqueado': 'Premium Pack',
      'menu_seccion': 'Choose an adventure to color',
      'libro_infinito': 'Infinite Coloring Book',
      'libro_infinito_desc': 'Your own drawings, without limits',
      'compra_unica': 'One-time purchase',
      'desbloqueado': 'Unlocked',
      'restaurar_compras': 'Restore purchase',
      'restaurando_compras': 'Looking for your previous purchase…',
      'solo_adultos': 'Adults only',
      'pregunta_adulto':
          'To continue with this action, ask an adult for help and solve:',
      'respuesta': 'Answer',
      'respuesta_incorrecta': 'Incorrect answer',
      'comprobar': 'Check',
      'limpiar_titulo': 'Start over?',
      'limpiar_desc': 'Strokes and stickers on this drawing will be cleared.',
      'limpiar': 'Clear',
      'compartir': 'Share',
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
          'Olha a minha obra de arte criada no O Mundo da Alegria! 🎨 $playUrl',
      'premium_titulo': 'Desbloqueie o Livro Infinito',
      'premium_desc':
          'Importe seus próprios desenhos e crie uma biblioteca que pode continuar crescendo. Uma compra, sem assinatura.',
      'premium_boton': 'Desbloquear Livro Infinito',
      'pack_bloqueado': 'Pacote Premium',
      'menu_seccion': 'Escolha uma aventura para colorir',
      'libro_infinito': 'Livro Infinito',
      'libro_infinito_desc': 'Seus próprios desenhos, sem limites',
      'compra_unica': 'Compra única',
      'desbloqueado': 'Desbloqueado',
      'restaurar_compras': 'Restaurar compra',
      'restaurando_compras': 'Procurando sua compra anterior…',
      'solo_adultos': 'Área para adultos',
      'pregunta_adulto':
          'Para continuar com esta ação, peça ajuda a um adulto e resolva:',
      'respuesta': 'Resposta',
      'respuesta_incorrecta': 'Resposta incorreta',
      'comprobar': 'Verificar',
      'limpiar_titulo': 'Começar de novo?',
      'limpiar_desc': 'Os traços e adesivos deste desenho serão apagados.',
      'limpiar': 'Limpar',
      'compartir': 'Compartilhar',
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
          'Schau dir mein Kunstwerk aus Die Welt der Freude an! 🎨 $playUrl',
      'premium_titulo': 'Unendliches Malbuch freischalten',
      'premium_desc':
          'Importiere deine eigenen Zeichnungen und baue eine Bibliothek auf, die weiter wachsen kann. Einmaliger Kauf, kein Abo.',
      'premium_boton': 'Unendliches Malbuch freischalten',
      'pack_bloqueado': 'Premium-Paket',
      'menu_seccion': 'Wähle ein Abenteuer zum Ausmalen',
      'libro_infinito': 'Unendliches Malbuch',
      'libro_infinito_desc': 'Deine eigenen Zeichnungen, ohne Limit',
      'compra_unica': 'Einmaliger Kauf',
      'desbloqueado': 'Freigeschaltet',
      'restaurar_compras': 'Kauf wiederherstellen',
      'restaurando_compras': 'Früheren Kauf suchen…',
      'solo_adultos': 'Nur für Erwachsene',
      'pregunta_adulto':
          'Bitte einen Erwachsenen um Hilfe und löse diese Aufgabe:',
      'respuesta': 'Antwort',
      'respuesta_incorrecta': 'Falsche Antwort',
      'comprobar': 'Prüfen',
      'limpiar_titulo': 'Neu anfangen?',
      'limpiar_desc': 'Striche und Sticker auf diesem Bild werden gelöscht.',
      'limpiar': 'Löschen',
      'compartir': 'Teilen',
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
          'Regarde mon œuvre créée dans Le Monde de la Joie ! 🎨 $playUrl',
      'premium_titulo': 'Débloquer le Livre Infini',
      'premium_desc':
          'Importe tes propres dessins et crée une bibliothèque qui peut continuer à grandir. Un seul achat, sans abonnement.',
      'premium_boton': 'Débloquer le Livre Infini',
      'pack_bloqueado': 'Pack Premium',
      'menu_seccion': 'Choisis une aventure à colorier',
      'libro_infinito': 'Livre Infini',
      'libro_infinito_desc': 'Tes propres dessins, sans limites',
      'compra_unica': 'Achat unique',
      'desbloqueado': 'Débloqué',
      'restaurar_compras': 'Restaurer l’achat',
      'restaurando_compras': 'Recherche de ton achat précédent…',
      'solo_adultos': 'Espace adultes',
      'pregunta_adulto':
          'Pour continuer cette action, demande de l’aide à un adulte et résous :',
      'respuesta': 'Réponse',
      'respuesta_incorrecta': 'Réponse incorrecte',
      'comprobar': 'Vérifier',
      'limpiar_titulo': 'Recommencer ?',
      'limpiar_desc': 'Les traits et autocollants de ce dessin seront effacés.',
      'limpiar': 'Effacer',
      'compartir': 'Partager',
    }
  };

  static void inicializar([String? idiomaGuardado]) {
    if (idiomaGuardado != null && _diccionario.containsKey(idiomaGuardado)) {
      _idiomaActual = idiomaGuardado;
      return;
    }

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
