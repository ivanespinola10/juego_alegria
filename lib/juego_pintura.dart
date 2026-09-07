import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:floodfill_image/floodfill_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/rendering.dart';

import 'idiomas.dart';
import 'servicio_audio.dart';
import 'zona_adultos.dart';
import 'textos_adultos.dart';

class Trazo {
  final List<Offset> puntos;
  final Color color;
  final double grosor;
  final bool esMarcador;
  Trazo({
    required this.puntos,
    required this.color,
    required this.grosor,
    this.esMarcador = false,
  });
}

class JuegoPintura extends StatefulWidget {
  final List<String> dibujos;
  final String titulo;
  final Color colorBase;
  final bool esNativo;

  const JuegoPintura({
    super.key,
    required this.dibujos,
    required this.titulo,
    required this.colorBase,
    required this.esNativo,
  });

  @override
  State<JuegoPintura> createState() => _JuegoPinturaState();
}

class _JuegoPinturaState extends State<JuegoPintura> {
  late Color colorSeleccionado;
  int indiceActual = 0;
  Key lienzoKey = UniqueKey();

  final GlobalKey _capturaKey = GlobalKey();

  final ValueNotifier<List<Widget>> _sellosNotifier = ValueNotifier([]);
  final ValueNotifier<List<Trazo>> _trazosNotifier = ValueNotifier([]);
  Trazo? _trazoActual;
  bool _hayCambios = false;
  bool _confirmando = false;
  bool _compartiendo = false;

  void _marcarCambio() {
    if (!_hayCambios) setState(() => _hayCambios = true);
  }

  Future<bool> _confirmarDescarte() async {
    if (!_hayCambios) return true;
    if (_confirmando || _compartiendo) return false;
    _confirmando = true;
    try {
      return await showDialog<bool>(
            context: context,
            builder: (dialogContext) => AlertDialog(
              scrollable: true,
              title: Text(textoAdulto('discard')),
              content: Text(textoAdulto('discardDetail')),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: Text(textoAdulto('cancel')),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: Text(textoAdulto('yesDiscard')),
                ),
              ],
            ),
          ) ??
          false;
    } finally {
      _confirmando = false;
    }
  }

  Future<void> _salir() async {
    if (_compartiendo || !await _confirmarDescarte() || !mounted) return;
    setState(() => _hayCambios = false);
    // Let PopScope receive canPop=true before popping the route.
    await WidgetsBinding.instance.endOfFrame;
    if (mounted) Navigator.pop(context);
  }

  String modoHerramienta = 'pintura';
  String categoriaSelloActual = '😀';
  String selloActual = '⭐';

  // 🚀 Colección ampliada de stickers por categoría
  final Map<String, List<String>> coleccionSellos = {
    '😀': [
      '😀',
      '😂',
      '😍',
      '😎',
      '😜',
      '😭',
      '😡',
      '🤯',
      '😴',
      '🥳',
      '👽',
      '👻',
      '💩',
      '🤖',
      '🤠',
      '😇',
      '🦄',
      '🤡',
      '🤠',
      '🥳',
      '😻',
      '🐶',
      '🦊',
      '🦁',
    ],
    '🐶': [
      '🐶',
      '🐱',
      '🐭',
      '🐰',
      '🦊',
      '🐻',
      '🐼',
      '🐯',
      '🦁',
      '🐮',
      '🐷',
      '🐸',
      '🐵',
      '🦖',
      '🐢',
      '🦄',
      '🐤',
      '🐧',
      ' koala',
      '🐙',
      '🦀',
      '🐳',
      '🐬',
      '🦋',
    ],
    '🍎': [
      '🍎',
      '🍌',
      '🍉',
      '🍇',
      '🍓',
      '🍒',
      '🍕',
      '🍔',
      '🍟',
      '🍩',
      '🍦',
      '🍰',
      '🍫',
      '🍬',
      '🍭',
      '🌮',
      '🍍',
      '🥑',
      '🍿',
      '🍪',
      '🥞',
      '🍯',
      '🍧',
      '🧃',
    ],
    '⭐': [
      '⭐',
      '💖',
      '👑',
      '🌸',
      '🎈',
      '🚗',
      '🚀',
      '🌈',
      '🎸',
      '🪄',
      '💎',
      '🎀',
      '⚽',
      '🏀',
      '🎨',
      '🎯',
      '⚡',
      '🔥',
      '⛄',
      '🧸',
      '🚀',
      '🛸',
      '⛵',
      '🏆',
    ],
  };

  final List<Color> paletaBase = const [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.teal,
    Colors.cyan,
    Colors.indigo,
    Colors.grey,
    Colors.black,
  ];

  @override
  void initState() {
    super.initState();
    colorSeleccionado = widget.colorBase;
    selloActual = coleccionSellos['⭐']!.first;
    _iniciarMusica();
  }

  Future<void> _iniciarMusica() async {
    await ServicioAudio.instance.iniciarMusica();
  }

  void _playPop() {
    ServicioAudio.instance.playPop();
  }

  void _toggleAudio() {
    ServicioAudio.instance.toggleAudio();
  }

  @override
  void dispose() {
    _sellosNotifier.dispose();
    _trazosNotifier.dispose();
    super.dispose();
  }

  Future<void> _cambiarDibujo(int paso) async {
    if (_compartiendo || !await _confirmarDescarte() || !mounted) return;
    setState(() {
      indiceActual = (indiceActual + paso) % widget.dibujos.length;
      _reiniciarLienzo();
    });
  }

  Future<void> _limpiarLienzoCompleto() async {
    if (_compartiendo || !await _confirmarDescarte() || !mounted) return;
    setState(_reiniciarLienzo);
  }

  void _reiniciarLienzo() {
    lienzoKey = UniqueKey();
    _sellosNotifier.value = [];
    _trazosNotifier.value = [];
    _trazoActual = null;
    _hayCambios = false;
  }

  void _deshacerUltimaAccion() {
    if (modoHerramienta == 'sellos' && _sellosNotifier.value.isNotEmpty) {
      final nuevaLista = List<Widget>.from(_sellosNotifier.value);
      nuevaLista.removeLast();
      _sellosNotifier.value = nuevaLista;
    } else if ((modoHerramienta == 'pincel' || modoHerramienta == 'marcador') &&
        _trazosNotifier.value.isNotEmpty) {
      final nuevaLista = List<Trazo>.from(_trazosNotifier.value);
      nuevaLista.removeLast();
      _trazosNotifier.value = nuevaLista;
    }
  }

  Future<void> _guardarImagen() async {
    if (_compartiendo || kIsWeb) return;
    setState(() => _compartiendo = true);
    ui.Image? image;
    try {
      if (!await solicitarAdulto(context) || !mounted) return;
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;
      RenderRepaintBoundary boundary =
          _capturaKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      final lado = boundary.size.longestSide;
      image = await boundary.toImage(pixelRatio: (2048 / lado).clamp(0.1, 2.0));
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final imagePath = await File(
        '${directory.path}/obra_${DateTime.now().microsecondsSinceEpoch}.png',
      ).create();
      await imagePath.writeAsBytes(pngBytes);

      if (!mounted) return;
      final box = context.findRenderObject() as RenderBox;
      await Share.shareXFiles(
        [XFile(imagePath.path)],
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
        text: Traductor.get('compartir_texto'),
      );
    } catch (e) {
      debugPrint("Error al guardar la imagen: $e");
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(textoAdulto('shareError'))));
      }
    } finally {
      image?.dispose();
      if (mounted) setState(() => _compartiendo = false);
    }
  }

  void _seleccionarOMezclarColor(Color nuevoColor) {
    _playPop();
    setState(() => colorSeleccionado = nuevoColor);
  }

  void _mezclarColor(Color nuevoColor) {
    setState(() {
      if (nuevoColor == Colors.white ||
          colorSeleccionado == Colors.white ||
          colorSeleccionado == Colors.black) {
        colorSeleccionado = nuevoColor;
      } else {
        colorSeleccionado = Color.lerp(colorSeleccionado, nuevoColor, 0.5)!;
      }
    });
  }

  void _aclararTono() {
    _playPop();
    setState(
      () => colorSeleccionado = Color.lerp(
        colorSeleccionado,
        Colors.white,
        0.25,
      )!,
    );
  }

  void _oscurecerTono() {
    _playPop();
    setState(
      () => colorSeleccionado = Color.lerp(
        colorSeleccionado,
        Colors.black,
        0.25,
      )!,
    );
  }

  void _pegarSello(TapUpDetails details) {
    if (modoHerramienta != 'sellos') return;
    _marcarCambio();
    _playPop();
    final nuevoSello = Positioned(
      left: details.localPosition.dx - 25,
      top: details.localPosition.dy - 25,
      child: TweenAnimationBuilder(
        duration: MediaQuery.of(context).disableAnimations
            ? Duration.zero
            : const Duration(milliseconds: 150),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, double val, child) =>
            Transform.scale(scale: val, child: child),
        child: Text(selloActual, style: const TextStyle(fontSize: 50)),
      ),
    );
    _sellosNotifier.value = [..._sellosNotifier.value, nuevoSello];
  }

  void _mostrarSubpantallaHerramientas() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Traductor.get('caja_herramientas'),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: [
                  _buildHerramientaCard(
                    icono: Icons.format_color_fill_rounded,
                    color: Colors.blue,
                    titulo: Traductor.get('pintura'),
                    activo: modoHerramienta == 'pintura',
                    onTap: () {
                      _playPop();
                      setState(() {
                        modoHerramienta = 'pintura';
                        colorSeleccionado = widget.colorBase;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  _buildHerramientaCard(
                    icono: Icons.brush_rounded,
                    color: Colors.purple,
                    titulo: Traductor.get('pincel'),
                    activo: modoHerramienta == 'pincel',
                    onTap: () {
                      _playPop();
                      setState(() => modoHerramienta = 'pincel');
                      Navigator.pop(context);
                    },
                  ),
                  _buildHerramientaCard(
                    icono: Icons.draw_rounded,
                    color: Colors.green,
                    titulo: Traductor.get('marcador'),
                    activo: modoHerramienta == 'marcador',
                    onTap: () {
                      _playPop();
                      setState(() => modoHerramienta = 'marcador');
                      Navigator.pop(context);
                    },
                  ),
                  _buildHerramientaCard(
                    icono: Icons.cleaning_services_rounded,
                    color: Colors.grey.shade600,
                    titulo: Traductor.get('borrador'),
                    activo: colorSeleccionado == Colors.white,
                    onTap: () {
                      _playPop();
                      setState(() {
                        modoHerramienta = 'pincel';
                        colorSeleccionado = Colors.white;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  _buildHerramientaCard(
                    icono: Icons.star_rounded,
                    color: Colors.orange,
                    titulo: Traductor.get('Stickers'),
                    activo: modoHerramienta == 'sellos',
                    onTap: () {
                      _playPop();
                      setState(() => modoHerramienta = 'sellos');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 25),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  Traductor.get('cerrar'),
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHerramientaCard({
    required IconData icono,
    required Color color,
    required String titulo,
    required bool activo,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        height: 110,
        decoration: BoxDecoration(
          color: activo ? color.withValues(alpha: 0.15) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: activo ? color : Colors.transparent,
            width: 3,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, size: 36, color: color),
            const SizedBox(height: 8),
            Text(
              titulo,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String rutaDibujo = widget.dibujos[indiceActual];
    final ImageProvider proveedorImagen =
        (rutaDibujo.startsWith('assets/') || kIsWeb)
        ? AssetImage(rutaDibujo)
        : FileImage(File(rutaDibujo)) as ImageProvider;

    final lienzoBase = FloodFillImage(
      key: lienzoKey,
      imageProvider: proveedorImagen,
      fillColor: colorSeleccionado,
      avoidColor: const [Colors.black],
      tolerance: 8,
    );

    return PopScope(
      canPop: !_hayCambios && !_compartiendo,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _salir();
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                minScale: 1.0,
                maxScale: 4.0,
                panEnabled:
                    modoHerramienta == 'pintura' || modoHerramienta == 'sellos',
                scaleEnabled: true,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Center(
                      child: SizedBox(
                        height: constraints.maxHeight,
                        child: RepaintBoundary(
                          key: _capturaKey,
                          child: AspectRatio(
                            aspectRatio: 4 / 3,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                IgnorePointer(
                                  ignoring: modoHerramienta != 'pintura',
                                  child: Listener(
                                    // Conservative: a bucket tap may alter its internal image.
                                    onPointerDown: (_) => _marcarCambio(),
                                    child: RepaintBoundary(child: lienzoBase),
                                  ),
                                ),
                                Positioned.fill(
                                  child: IgnorePointer(
                                    ignoring:
                                        modoHerramienta != 'pincel' &&
                                        modoHerramienta != 'marcador',
                                    child: GestureDetector(
                                      onPanStart: (details) {
                                        _marcarCambio();
                                        _trazoActual = Trazo(
                                          puntos: [details.localPosition],
                                          color: colorSeleccionado,
                                          grosor: modoHerramienta == 'marcador'
                                              ? 25.0
                                              : 8.0,
                                          esMarcador:
                                              modoHerramienta == 'marcador',
                                        );
                                        _trazosNotifier.value = List.from(
                                          _trazosNotifier.value,
                                        )..add(_trazoActual!);
                                      },
                                      onPanUpdate: (details) {
                                        if (_trazoActual != null) {
                                          _trazoActual!.puntos.add(
                                            details.localPosition,
                                          );
                                          _trazosNotifier.value = List.from(
                                            _trazosNotifier.value,
                                          );
                                        }
                                      },
                                      onPanEnd: (details) =>
                                          _trazoActual = null,
                                      onPanCancel: () => _trazoActual = null,
                                      child:
                                          ValueListenableBuilder<List<Trazo>>(
                                            valueListenable: _trazosNotifier,
                                            builder: (context, trazos, _) =>
                                                CustomPaint(
                                                  painter: DibujoPainter(
                                                    trazos,
                                                  ),
                                                ),
                                          ),
                                    ),
                                  ),
                                ),
                                ValueListenableBuilder<List<Widget>>(
                                  valueListenable: _sellosNotifier,
                                  builder: (context, sellos, child) =>
                                      Stack(children: sellos),
                                ),
                                if (modoHerramienta == 'sellos')
                                  Positioned.fill(
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTapUp: _pegarSello,
                                      child: Container(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // UI SUPERIOR
            Positioned(
              top: 10,
              left: 15,
              right: 15,
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildBotonFlotante(
                      Icons.close_rounded,
                      _salir,
                      color: Colors.red,
                    ),
                    Row(
                      children: [
                        ValueListenableBuilder<bool>(
                          valueListenable:
                              ServicioAudio.instance.audioActivoNotifier,
                          builder: (context, audioActivo, _) {
                            return _buildBotonFlotante(
                              audioActivo
                                  ? Icons.volume_up_rounded
                                  : Icons.volume_off_rounded,
                              _toggleAudio,
                              color: audioActivo ? Colors.green : Colors.grey,
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildBotonFlotante(
                          Icons.share_rounded,
                          _guardarImagen,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        _buildBotonFlotante(
                          Icons.undo_rounded,
                          _deshacerUltimaAccion,
                        ),
                        const SizedBox(width: 8),
                        _buildBotonFlotante(
                          Icons.delete_sweep_rounded,
                          _limpiarLienzoCompleto,
                        ),
                        const SizedBox(width: 8),
                        _buildBotonFlotante(
                          Icons.navigate_before_rounded,
                          () => _cambiarDibujo(-1),
                        ),
                        const SizedBox(width: 8),
                        _buildBotonFlotante(
                          Icons.navigate_next_rounded,
                          () => _cambiarDibujo(1),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // UI INFERIOR UX/UI IDÉNTICA A AI STUDIO
            Positioned(
              bottom: 15,
              left: 15,
              right: 15,
              child: SafeArea(
                child: Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Botón de Herramienta Activa (Estilo AI Studio)
                      GestureDetector(
                        onTap: _mostrarSubpantallaHerramientas,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                modoHerramienta == 'sellos'
                                    ? Icons.star_rounded
                                    : (modoHerramienta == 'pincel'
                                          ? Icons.brush_rounded
                                          : (modoHerramienta == 'marcador'
                                                ? Icons.draw_rounded
                                                : Icons
                                                      .format_color_fill_rounded)),
                                color: Colors.deepPurple,
                                size: 24,
                              ),
                              const SizedBox(width: 6),
                              // 🚀 Texto dinámico corregido para que no se corte
                              Text(
                                Traductor.get(
                                  colorSeleccionado == Colors.white &&
                                          modoHerramienta == 'pincel'
                                      ? 'borrador'
                                      : modoHerramienta == 'sellos'
                                      ? 'Stickers'
                                      : modoHerramienta,
                                ),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Laboratorio Flotante Compacto
                      if (modoHerramienta != 'sellos') ...[
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.nightlight_round,
                                color: Colors.blueGrey,
                                size: 18,
                              ),
                              onPressed: _oscurecerTono,
                              constraints: const BoxConstraints(
                                minWidth: 30,
                                minHeight: 30,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: colorSeleccionado,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black87,
                                  width: 2,
                                ),
                              ),
                              child: colorSeleccionado == Colors.white
                                  ? const Icon(
                                      Icons.cleaning_services_rounded,
                                      color: Colors.black38,
                                      size: 16,
                                    )
                                  : null,
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.wb_sunny_rounded,
                                color: Colors.amber,
                                size: 18,
                              ),
                              onPressed: _aclararTono,
                              constraints: const BoxConstraints(
                                minWidth: 30,
                                minHeight: 30,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                      ],

                      // Paleta o Stickers Extendidos
                      Expanded(
                        child: modoHerramienta == 'sellos'
                            ? _buildStickerPalette()
                            : _buildColorPalette(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotonFlotante(
    IconData icono,
    VoidCallback onTap, {
    Color color = Colors.black87,
  }) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10),
        ],
      ),
      child: IconButton(
        tooltip: textoAdulto(
          icono == Icons.close_rounded
              ? 'close'
              : icono == Icons.share_rounded
              ? 'share'
              : icono == Icons.undo_rounded
              ? 'undo'
              : icono == Icons.delete_sweep_rounded
              ? 'clear'
              : icono == Icons.navigate_before_rounded
              ? 'previous'
              : icono == Icons.navigate_next_rounded
              ? 'next'
              : 'audio',
        ),
        icon: Icon(icono, color: color, size: 24),
        onPressed: _compartiendo ? null : onTap,
      ),
    );
  }

  Widget _buildStickerPalette() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 22,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: coleccionSellos.keys.map((catIcon) {
              final isActivo = categoriaSelloActual == catIcon;
              return GestureDetector(
                onTap: () {
                  _playPop();
                  setState(() {
                    categoriaSelloActual = catIcon;
                    selloActual = coleccionSellos[catIcon]!.first;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Opacity(
                    opacity: isActivo ? 1.0 : 0.4,
                    child: Text(catIcon, style: const TextStyle(fontSize: 14)),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: coleccionSellos[categoriaSelloActual]!.length,
            itemBuilder: (context, index) {
              final sello = coleccionSellos[categoriaSelloActual]![index];
              return GestureDetector(
                onTap: () {
                  _playPop();
                  setState(() => selloActual = sello);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Center(
                    child: Text(
                      sello,
                      style: TextStyle(
                        fontSize: selloActual == sello ? 30 : 22,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildColorPalette() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: paletaBase.length,
      itemBuilder: (context, index) {
        final c = paletaBase[index];
        final bool isSelected = colorSeleccionado == c;
        return GestureDetector(
          onTap: () => _seleccionarOMezclarColor(c),
          onLongPress: () => _mezclarColor(c),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            width: isSelected ? 38 : 30,
            decoration: BoxDecoration(
              color: c,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.black : Colors.black12,
                width: isSelected ? 3 : 2,
              ),
              boxShadow: isSelected
                  ? [BoxShadow(color: c.withValues(alpha: 0.5), blurRadius: 8)]
                  : [],
            ),
            child: c == Colors.white
                ? const Icon(
                    Icons.cleaning_services_rounded,
                    color: Colors.black54,
                    size: 16,
                  )
                : null,
          ),
        );
      },
    );
  }
}

class DibujoPainter extends CustomPainter {
  final List<Trazo> trazos;
  DibujoPainter(this.trazos);

  @override
  void paint(Canvas canvas, Size size) {
    for (var trazo in trazos) {
      final paint = Paint()
        ..color = trazo.esMarcador
            ? trazo.color.withValues(alpha: 0.5)
            : trazo.color
        ..strokeWidth = trazo.grosor
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      if (trazo.puntos.length > 1) {
        for (int i = 0; i < trazo.puntos.length - 1; i++) {
          canvas.drawLine(trazo.puntos[i], trazo.puntos[i + 1], paint);
        }
      } else if (trazo.puntos.isNotEmpty) {
        canvas.drawPoints(ui.PointMode.points, [trazo.puntos.first], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
