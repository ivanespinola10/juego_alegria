import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:floodfill_image/floodfill_image.dart';
import 'package:confetti/confetti.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'servicio_audio.dart';
import 'gestor_archivos.dart';
import 'package:flutter/rendering.dart';

// 🚀 CLASE PARA GUARDAR LOS TRAZOS A MANO ALZADA
class Trazo {
  final List<Offset> puntos;
  final Color color;
  final double grosor;
  final bool esMarcador;
  Trazo(
      {required this.puntos,
      required this.color,
      required this.grosor,
      this.esMarcador = false});
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

  late ConfettiController _confettiController;
  late final ValueNotifier<bool> _blindajeNotifier;
  final ValueNotifier<List<Widget>> _sellosNotifier = ValueNotifier([]);

  final ValueNotifier<List<Trazo>> _trazosNotifier = ValueNotifier([]);
  Trazo? _trazoActual;

  String? plantillaSeleccionada;

  // 🚀 CACHÉ DE MEMORIA PARA ELIMINAR EL LAG DEL CONFETI
  final Map<Size, Path> _estrellasEnCache = {};

  final List<String> _plantillasAbecedario = [
    'assets/Abecedario_MundoAlegria/1_letra_A.png',
    'assets/Abecedario_MundoAlegria/2_letra_B.png',
    'assets/Abecedario_MundoAlegria/3_letra_C.png',
    'assets/Abecedario_MundoAlegria/4_letra_D.png',
    'assets/Abecedario_MundoAlegria/5_letra_E.png',
    'assets/Abecedario_MundoAlegria/6_letra_F.png',
    'assets/Abecedario_MundoAlegria/7_letra_G.png',
    'assets/Abecedario_MundoAlegria/8_letra_H.png',
    'assets/Abecedario_MundoAlegria/9_letra_I.png',
    'assets/Abecedario_MundoAlegria/10_letra_J.png',
    'assets/Abecedario_MundoAlegria/11_letra_K.png',
    'assets/Abecedario_MundoAlegria/12_letra_L.png',
    'assets/Abecedario_MundoAlegria/13_letra_M.png',
    'assets/Abecedario_MundoAlegria/14_letra_N.png',
    'assets/Abecedario_MundoAlegria/15_letra_O.png',
    'assets/Abecedario_MundoAlegria/16_letra_P.png',
    'assets/Abecedario_MundoAlegria/17_letra_Q.png',
    'assets/Abecedario_MundoAlegria/18_letra_R.png',
    'assets/Abecedario_MundoAlegria/19_letra_S.png',
    'assets/Abecedario_MundoAlegria/20_letra_T.png',
    'assets/Abecedario_MundoAlegria/21_letra_U.png',
    'assets/Abecedario_MundoAlegria/22_letra_V.png',
    'assets/Abecedario_MundoAlegria/23_letra_W.png',
    'assets/Abecedario_MundoAlegria/24_letra_X.png',
    'assets/Abecedario_MundoAlegria/25_letra_Y.png',
    'assets/Abecedario_MundoAlegria/26_letra_Z.png',
    'assets/Abecedario_MundoAlegria/portada.png',
  ];

  // ESTADOS DE HERRAMIENTA
  String modoHerramienta = 'pintura';
  String categoriaSelloActual = '😀';
  String selloActual = '⭐';

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
      '🤖'
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
      '🦄'
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
      '🌮'
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
      '🎯'
    ],
  };

  final List<Color> paletaBase = const [
    Colors.white,
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.black,
  ];

  bool get _necesitaBlindajeMouse =>
      kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  @override
  void initState() {
    super.initState();
    colorSeleccionado = widget.colorBase;
    selloActual = coleccionSellos['⭐']!.first;
    _blindajeNotifier = ValueNotifier(_necesitaBlindajeMouse);
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
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
    _confettiController.dispose();
    _blindajeNotifier.dispose();
    _sellosNotifier.dispose();
    _trazosNotifier.dispose();
    super.dispose();
  }

  void _cambiarDibujo(int paso) {
    setState(() {
      indiceActual = (indiceActual + paso) % widget.dibujos.length;
      if (indiceActual < 0) indiceActual = widget.dibujos.length - 1;
      plantillaSeleccionada = null;
      _limpiarLienzoCompleto();
    });
  }

  void _limpiarLienzoCompleto() {
    setState(() {
      lienzoKey = UniqueKey();
      _sellosNotifier.value = [];
      _trazosNotifier.value = [];
    });
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
    try {
      RenderRepaintBoundary boundary = _capturaKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final imagePath =
          await File('${directory.path}/obra_maestra.png').create();
      await imagePath.writeAsBytes(pngBytes);

      await Share.shareXFiles([XFile(imagePath.path)],
          text: '¡Mira mi obra de arte creada en El Mundo de Alegría!');
    } catch (e) {
      debugPrint("Error al guardar la imagen: $e");
    }
  }

  void _seleccionarOMezclarColor(Color nuevoColor) {
    _playPop();
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
    setState(() =>
        colorSeleccionado = Color.lerp(colorSeleccionado, Colors.white, 0.25)!);
  }

  void _oscurecerTono() {
    _playPop();
    setState(() =>
        colorSeleccionado = Color.lerp(colorSeleccionado, Colors.black, 0.25)!);
  }

  void _pegarSello(TapUpDetails details) {
    if (modoHerramienta != 'sellos') return;
    _playPop();
    final nuevoSello = Positioned(
      left: details.localPosition.dx - 25,
      top: details.localPosition.dy - 25,
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 300),
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
          width: 450,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 5)
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Caja de Herramientas",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple)),
              const SizedBox(height: 20),
              Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: [
                  _buildHerramientaIcono(
                    icono: Icons.format_color_fill_rounded,
                    color: Colors.blue,
                    titulo: "Pintura",
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
                  _buildHerramientaIcono(
                    icono: Icons.brush_rounded,
                    color: Colors.purple,
                    titulo: "Pincel",
                    activo: modoHerramienta == 'pincel',
                    onTap: () {
                      _playPop();
                      setState(() => modoHerramienta = 'pincel');
                      Navigator.pop(context);
                    },
                  ),
                  _buildHerramientaIcono(
                    icono: Icons.draw_rounded,
                    color: Colors.green,
                    titulo: "Marcador",
                    activo: modoHerramienta == 'marcador',
                    onTap: () {
                      _playPop();
                      setState(() => modoHerramienta = 'marcador');
                      Navigator.pop(context);
                    },
                  ),
                  _buildHerramientaIcono(
                    icono: Icons.cleaning_services_rounded,
                    color: Colors.grey.shade600,
                    titulo: "Borrador",
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
                  _buildHerramientaIcono(
                    icono: Icons.collections_rounded,
                    color: Colors.teal,
                    titulo: "Plantillas",
                    activo: false,
                    onTap: () {
                      _playPop();
                      Navigator.pop(context);
                      _mostrarSubpantallaPlantillas();
                    },
                  ),
                  // 🚀 BOTÓN IMPORTAR LIBERADO (Sin Candado)
                  _buildHerramientaIcono(
                    icono: Icons.add_photo_alternate_rounded,
                    color: Colors.indigo,
                    titulo: "Importar",
                    activo: false,
                    onTap: () async {
                      _playPop();
                      Navigator.pop(context);
                      // Flujo directo: Al ser una App de Pago Único, ya tienen acceso total.
                      await GestorArchivos.importarArchivosDirectos();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cerrar",
                      style: TextStyle(fontSize: 16, color: Colors.grey))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHerramientaIcono(
      {required IconData icono,
      required Color color,
      required String titulo,
      required bool activo,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: activo ? color.withValues(alpha: 0.2) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: activo ? color : Colors.transparent, width: 3),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, size: 40, color: color),
            const SizedBox(height: 5),
            Text(titulo,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                    fontSize: 12)),
          ],
        ),
      ),
    );
  }

  void _mostrarSubpantallaPlantillas() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding:
            const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 20),
        decoration: const BoxDecoration(
          color: Color(0xFFFFF0F5),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 5,
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Text(
              "Plantillas",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _plantillasAbecedario.length,
                itemBuilder: (context, index) {
                  final ruta = _plantillasAbecedario[index];
                  return GestureDetector(
                    onTap: () {
                      _playPop();
                      setState(() {
                        plantillaSeleccionada = ruta;
                        _limpiarLienzoCompleto();
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border:
                            Border.all(color: Colors.teal.shade200, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Image.asset(ruta, fit: BoxFit.contain),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String rutaDibujo =
        plantillaSeleccionada ?? widget.dibujos[indiceActual];
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

    return Scaffold(
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
              // 🚀 LIENZO RESPONSIVO (LayoutBuilder)
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: SizedBox(
                      height: constraints
                          .maxHeight, // Estira al máximo verticalmente
                      child: RepaintBoundary(
                        key: _capturaKey,
                        child: AspectRatio(
                          aspectRatio:
                              4 / 3, // Mantiene proporción para no deformar
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              IgnorePointer(
                                ignoring: modoHerramienta != 'pintura',
                                child: RepaintBoundary(child: lienzoBase),
                              ),
                              Positioned.fill(
                                child: IgnorePointer(
                                  ignoring: modoHerramienta != 'pincel' &&
                                      modoHerramienta != 'marcador',
                                  child: GestureDetector(
                                    onPanStart: (details) {
                                      _trazoActual = Trazo(
                                        puntos: [details.localPosition],
                                        color: colorSeleccionado,
                                        grosor: modoHerramienta == 'marcador'
                                            ? 25.0
                                            : 8.0,
                                        esMarcador:
                                            modoHerramienta == 'marcador',
                                      );
                                      _trazosNotifier.value =
                                          List.from(_trazosNotifier.value)
                                            ..add(_trazoActual!);
                                    },
                                    onPanUpdate: (details) {
                                      if (_trazoActual != null) {
                                        _trazoActual!.puntos
                                            .add(details.localPosition);
                                        _trazosNotifier.value =
                                            List.from(_trazosNotifier.value);
                                      }
                                    },
                                    onPanEnd: (details) => _trazoActual = null,
                                    child: ValueListenableBuilder<List<Trazo>>(
                                      valueListenable: _trazosNotifier,
                                      builder: (context, trazos, _) =>
                                          CustomPaint(
                                              painter: DibujoPainter(trazos)),
                                    ),
                                  ),
                                ),
                              ),
                              ValueListenableBuilder<List<Widget>>(
                                  valueListenable: _sellosNotifier,
                                  builder: (context, sellos, child) =>
                                      Stack(children: sellos)),
                              if (modoHerramienta == 'sellos')
                                Positioned.fill(
                                  child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTapUp: _pegarSello,
                                      child:
                                          Container(color: Colors.transparent)),
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
                      Icons.close_rounded, () => Navigator.pop(context),
                      color: Colors.red),
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
                          Icons.camera_alt_rounded, _guardarImagen,
                          color: Colors.blue),
                      const SizedBox(width: 8),
                      _buildBotonFlotante(
                          Icons.undo_rounded, _deshacerUltimaAccion),
                      const SizedBox(width: 8),
                      _buildBotonFlotante(
                          Icons.delete_sweep_rounded, _limpiarLienzoCompleto),
                      const SizedBox(width: 8),
                      _buildBotonFlotante(Icons.navigate_before_rounded,
                          () => _cambiarDibujo(-1)),
                      const SizedBox(width: 8),
                      _buildBotonFlotante(
                          Icons.navigate_next_rounded, () => _cambiarDibujo(1)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // UI INFERIOR
          Positioned(
            bottom: 10,
            left: 15,
            right: 15,
            child: SafeArea(
              child: SizedBox(
                height: 60,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _mostrarSubpantallaHerramientas,
                      child: Container(
                        width: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10)
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                                modoHerramienta == 'sellos'
                                    ? Icons.star_rounded
                                    : (modoHerramienta == 'pincel'
                                        ? Icons.brush_rounded
                                        : (modoHerramienta == 'marcador'
                                            ? Icons.draw_rounded
                                            : Icons.format_color_fill_rounded)),
                                color: Colors.deepPurple,
                                size: 26),
                            const Text("Herram.",
                                style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (modoHerramienta != 'sellos')
                      _buildLaboratorioFlotante(),
                    if (modoHerramienta != 'sellos') const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10)
                            ]),
                        child: modoHerramienta == 'sellos'
                            ? _buildStickerPalette()
                            : _buildColorPalette(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        _playPop();
                        _confettiController.play();
                      },
                      child: Container(
                        width: 60,
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.amber.withValues(alpha: 0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5))
                            ]),
                        child: const Icon(Icons.check_rounded,
                            color: Colors.white, size: 35),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
              createParticlePath: _dibujarEstrella,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotonFlotante(IconData icono, VoidCallback onTap,
      {Color color = Colors.black87}) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)
          ]),
      child: IconButton(
          icon: Icon(icono, color: color, size: 24), onPressed: onTap),
    );
  }

  Widget _buildLaboratorioFlotante() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)
          ]),
      child: Row(
        children: [
          IconButton(
              icon: const Icon(Icons.nightlight_round,
                  color: Colors.blueGrey, size: 18),
              onPressed: _oscurecerTono),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: colorSeleccionado,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2)),
            child: colorSeleccionado == Colors.white
                ? const Icon(Icons.cleaning_services_rounded,
                    color: Colors.black38, size: 16)
                : null,
          ),
          IconButton(
              icon: const Icon(Icons.wb_sunny_rounded,
                  color: Colors.amber, size: 18),
              onPressed: _aclararTono),
        ],
      ),
    );
  }

  Widget _buildStickerPalette() {
    return Column(
      children: [
        Container(
          height: 25,
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
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
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Opacity(
                        opacity: isActivo ? 1.0 : 0.4,
                        child: Text(catIcon,
                            style: const TextStyle(fontSize: 14)))),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: coleccionSellos[categoriaSelloActual]!.length,
            itemBuilder: (context, index) {
              final sello = coleccionSellos[categoriaSelloActual]![index];
              return GestureDetector(
                onTap: () {
                  _playPop();
                  setState(() => selloActual = sello);
                },
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                        child: Text(sello,
                            style: TextStyle(
                                fontSize: selloActual == sello ? 35 : 25)))),
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
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemCount: paletaBase.length,
      itemBuilder: (context, index) {
        final c = paletaBase[index];
        final bool isSelected = colorSeleccionado == c;
        return GestureDetector(
          onTap: () => _seleccionarOMezclarColor(c),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
            width: isSelected ? 40 : 30,
            decoration: BoxDecoration(
                color: c,
                shape: BoxShape.circle,
                border: Border.all(
                    color: isSelected ? Colors.black : Colors.black12,
                    width: isSelected ? 3 : 2),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                            color: c.withValues(alpha: 0.5), blurRadius: 10)
                      ]
                    : []),
            child: c == Colors.white
                ? const Icon(Icons.cleaning_services_rounded,
                    color: Colors.black54, size: 18)
                : null,
          ),
        );
      },
    );
  }

  Path _dibujarEstrella(Size size) {
    if (_estrellasEnCache.containsKey(size)) {
      return _estrellasEnCache[size]!;
    }
    double degToRad(double deg) => deg * (math.pi / 180.0);
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / 5);
    final halfDegreesPerStep = degreesPerStep / 2;

    final path = Path()..moveTo(size.width, halfWidth);
    for (double step = 0; step < degToRad(360); step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * math.cos(step),
          halfWidth + externalRadius * math.sin(step));
      path.lineTo(
          halfWidth + internalRadius * math.cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * math.sin(step + halfDegreesPerStep));
    }
    path.close();
    _estrellasEnCache[size] = path;

    return path;
  }
}

class DibujoPainter extends CustomPainter {
  final List<Trazo> trazos;
  DibujoPainter(this.trazos);

  @override
  void paint(Canvas canvas, Size size) {
    for (var trazo in trazos) {
      final paint = Paint()
        ..color =
            trazo.esMarcador ? trazo.color.withValues(alpha: 0.5) : trazo.color
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
