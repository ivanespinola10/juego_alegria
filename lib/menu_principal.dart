import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 🚀 ¡Esta línea faltaba!

import 'idiomas.dart';
import 'gestor_archivos.dart';
import 'juego_pintura.dart';
import 'servicio_audio.dart';
import 'zona_adultos.dart';
import 'textos_adultos.dart';

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({super.key});

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal>
    with WidgetsBindingObserver {
  List<CategoriaDinamica> _categoriasUsuario = [];
  bool _cargando = true;
  bool _importando = false;

  Future<void> _importarLamina() async {
    if (_importando || kIsWeb) return;
    setState(() => _importando = true);
    try {
      if (!await solicitarAdulto(context) || !mounted) return;
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      // Existing access is preserved; it is not proof of a paid transaction.
      final pro = prefs.getBool('es_pro') ?? false;
      final pruebaUsada =
          (prefs.getBool('importacion_prueba_usada') ?? false) ||
          _categoriasUsuario.isNotEmpty;
      if (!pro && pruebaUsada) {
        _mostrarPaywall();
        return;
      }
      final resultado = await GestorArchivos.importarArchivosDirectos(
        multiple: pro,
      );
      if (!pro && resultado.importados > 0) {
        await prefs.setBool('importacion_prueba_usada', true);
      }
      if (!mounted) return;
      if (resultado.importados + resultado.omitidos > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${textoAdulto('importDone')}: ${resultado.importados}. '
              '${textoAdulto('skipped')}: ${resultado.omitidos}.',
            ),
          ),
        );
      }
      await _cargarCarpetas();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(textoAdulto('importError'))));
      }
    } finally {
      if (mounted) setState(() => _importando = false);
    }
  }

  bool _esVersionesPro =
      false; // Estado del Paywall (Libro Infinito / Importar)

  final List<Map<String, dynamic>> _packsEstaticos = [
    {
      "titulo": "Capibaras",
      "subtitulo": "Mundo Relax",
      "icono": Icons.water_drop_rounded,
      "color": Colors.teal,
      "archivos": [
        "assets/capibara/1.png",
        "assets/capibara/2.png",
        "assets/capibara/3.png",
        "assets/capibara/4.png",
        "assets/capibara/5.png",
        "assets/capibara/6.png",
      ],
    },
    {
      "titulo": "Animalitos",
      "subtitulo": "Amigos Felices",
      "icono": Icons.pets_rounded,
      "color": Colors.orange,
      "archivos": [
        "assets/Animalitos/1A.png",
        "assets/Animalitos/2A.png",
        "assets/Animalitos/3A.png",
        "assets/Animalitos/4A.png",
        "assets/Animalitos/5A.png",
        "assets/Animalitos/6A.png",
      ],
    },
    {
      "titulo": "Dinosaurios",
      "subtitulo": "Mundo Jurásico",
      "icono": Icons.park_rounded,
      "color": Colors.green,
      "archivos": [
        "assets/Dino/1D.png",
        "assets/Dino/2D.png",
        "assets/Dino/3D.png",
        "assets/Dino/4D.png",
        "assets/Dino/5D.png",
        "assets/Dino/6D.png",
      ],
    },
    {
      "titulo": "Dino Bebés",
      "subtitulo": "Pequeños Amigos",
      "icono": Icons.favorite_rounded,
      "color": Colors.pink,
      "archivos": [
        "assets/Dinobebe/BD1.png",
        "assets/Dinobebe/BD2.png",
        "assets/Dinobebe/BD3.png",
        "assets/Dinobebe/BD4.png",
        "assets/Dinobebe/BD5.png",
        "assets/Dinobebe/BD11.png",
      ],
    },
    {
      "titulo": "Abecedario",
      "subtitulo": "Aprende las Letras",
      "icono": Icons.font_download_rounded,
      "color": Colors.blue,
      "archivos": [
        "assets/Abecedario_MundoAlegria/1_letra_A.png",
        "assets/Abecedario_MundoAlegria/2_letra_B.png",
        "assets/Abecedario_MundoAlegria/3_letra_C.png",
        "assets/Abecedario_MundoAlegria/4_letra_D.png",
        "assets/Abecedario_MundoAlegria/5_letra_E.png",
        "assets/Abecedario_MundoAlegria/6_letra_F.png",
        "assets/Abecedario_MundoAlegria/7_letra_G.png",
        "assets/Abecedario_MundoAlegria/8_letra_H.png",
        "assets/Abecedario_MundoAlegria/9_letra_I.png",
        "assets/Abecedario_MundoAlegria/10_letra_J.png",
        "assets/Abecedario_MundoAlegria/11_letra_K.png",
        "assets/Abecedario_MundoAlegria/12_letra_L.png",
        "assets/Abecedario_MundoAlegria/13_letra_M.png",
        "assets/Abecedario_MundoAlegria/14_letra_N.png",
        "assets/Abecedario_MundoAlegria/15_letra_O.png",
        "assets/Abecedario_MundoAlegria/16_letra_P.png",
        "assets/Abecedario_MundoAlegria/17_letra_Q.png",
        "assets/Abecedario_MundoAlegria/18_letra_R.png",
        "assets/Abecedario_MundoAlegria/19_letra_S.png",
        "assets/Abecedario_MundoAlegria/20_letra_T.png",
        "assets/Abecedario_MundoAlegria/21_letra_U.png",
        "assets/Abecedario_MundoAlegria/22_letra_V.png",
        "assets/Abecedario_MundoAlegria/23_letra_W.png",
        "assets/Abecedario_MundoAlegria/24_letra_X.png",
        "assets/Abecedario_MundoAlegria/25_letra_Y.png",
        "assets/Abecedario_MundoAlegria/26_letra_Z.png",
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cargarCarpetas();
    ServicioAudio.instance.iniciarMusica();
    _verificarEstadoPro();
  }

  Future<void> _verificarEstadoPro() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _esVersionesPro = prefs.getBool('es_pro') ?? false;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      ServicioAudio.instance.pausarMusica();
    } else if (state == AppLifecycleState.resumed) {
      ServicioAudio.instance.reanudarMusica();
    }
  }

  Future<void> _cargarCarpetas() async {
    setState(() => _cargando = true);
    if (kIsWeb) {
      setState(() {
        _categoriasUsuario = [];
        _cargando = false;
      });
      return;
    }
    final carpetas = await GestorArchivos.escanearCarpetasUsuario();
    if (!mounted) return;
    setState(() {
      _categoriasUsuario = carpetas;
      _cargando = false;
    });
  }

  Future<void> _eliminarCategoria(CategoriaDinamica cat) async {
    if (!await solicitarAdulto(context) || !mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          Traductor.get('borrar_pack'),
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(Traductor.get('borrar_aviso')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(Traductor.get('cancelar')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context);
              try {
                final directorio = Directory(cat.rutaDirectorio);
                if (await directorio.exists()) {
                  await directorio.delete(recursive: true);
                }
                if (mounted) await _cargarCarpetas();
              } catch (_) {
                if (mounted) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(content: Text(textoAdulto('deleteError'))),
                  );
                }
              }
            },
            child: Text(Traductor.get('si_borrar')),
          ),
        ],
      ),
    );
  }

  void _mostrarSelectorIdioma() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Seleccionar Idioma / Language",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOpcionIdioma('Español', 'es'),
            _buildOpcionIdioma('English', 'en'),
            _buildOpcionIdioma('Português', 'pt'),
            _buildOpcionIdioma('Deutsch', 'de'),
            _buildOpcionIdioma('Français', 'fr'),
          ],
        ),
      ),
    );
  }

  Widget _buildOpcionIdioma(String nombre, String codigo) {
    return ListTile(
      title: Text(nombre, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: Traductor.idiomaActual == codigo
          ? const Icon(Icons.check, color: Colors.deepPurple)
          : null,
      onTap: () async {
        ServicioAudio.instance.playPop();
        await Traductor.setIdioma(codigo);
        if (!context.mounted || !mounted) return;
        Navigator.pop(context);
        setState(() {});
      },
    );
  }

  void _mostrarPaywall() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          padding: const EdgeInsets.all(30),
          width: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.workspace_premium_rounded,
                  size: 70,
                  color: Colors.amber,
                ),
                const SizedBox(height: 15),
                Text(
                  textoAdulto('infinite'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${textoAdulto('offer')}\n\n${textoAdulto('trial')}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 5,
                  ),
                  // Never grant paid access until store billing is configured.
                  onPressed: null,
                  child: Text(
                    textoAdulto('coming'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    Traductor.get('cancelar'),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade50, Colors.blue.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            color: Colors.amber,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "El Mundo de Alegría",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _esVersionesPro
                                ? Colors.indigo
                                : Colors.deepPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 3,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          icon: Icon(
                            _esVersionesPro
                                ? Icons.add_photo_alternate_rounded
                                : Icons.lock_rounded,
                            size: 20,
                          ),
                          label: Text(
                            textoAdulto('import'),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: _importando || _cargando || kIsWeb
                              ? null
                              : _importarLamina,
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            ServicioAudio.instance.playPop();
                            _mostrarSelectorIdioma();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.language_rounded,
                                  size: 18,
                                  color: Colors.deepPurple,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  Traductor.idiomaActual.toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ValueListenableBuilder<bool>(
                          valueListenable:
                              ServicioAudio.instance.audioActivoNotifier,
                          builder: (context, audioActivo, _) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(
                                  audioActivo
                                      ? Icons.volume_up_rounded
                                      : Icons.volume_off_rounded,
                                  color: audioActivo
                                      ? Colors.deepPurple
                                      : Colors.grey,
                                  size: 24,
                                ),
                                onPressed: () {
                                  ServicioAudio.instance.playPop();
                                  ServicioAudio.instance.toggleAudio();
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 5),
                child: Text(
                  "Pintura y Dibujo",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Expanded(
                child: _cargando
                    ? const Center(child: CircularProgressIndicator())
                    : Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ..._packsEstaticos.map(
                                (pack) => _buildTarjetaEstatica(context, pack),
                              ),
                              ..._categoriasUsuario.map(
                                (cat) => _buildTarjetaDinamica(context, cat),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTarjetaEstatica(
    BuildContext context,
    Map<String, dynamic> pack,
  ) {
    final Color colorMascota = pack["color"];
    final IconData iconoData = pack["icono"] is IconData
        ? pack["icono"]
        : Icons.menu_book_rounded;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        ServicioAudio.instance.playPop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JuegoPintura(
              dibujos: List<String>.from(pack["archivos"]),
              titulo: pack["titulo"],
              colorBase: colorMascota,
              esNativo: false,
            ),
          ),
        );
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 240,
          height: 320,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: colorMascota.withValues(alpha: 0.3),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: colorMascota.withValues(alpha: 0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorMascota.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(iconoData, size: 60, color: colorMascota),
              ),
              const SizedBox(height: 20),
              Text(
                pack["titulo"],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorMascota,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                pack["subtitulo"],
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTarjetaDinamica(BuildContext context, CategoriaDinamica cat) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        ServicioAudio.instance.playPop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JuegoPintura(
              dibujos: cat.rutasDibujos,
              titulo: cat.nombre,
              colorBase: cat.colorBase,
              esNativo: true,
            ),
          ),
        );
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 240,
          height: 320,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: cat.colorBase.withValues(alpha: 0.3),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: cat.colorBase.withValues(alpha: 0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: cat.colorBase.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: cat.rutaPortada.isNotEmpty
                          ? Image.file(
                              File(cat.rutaPortada),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                    Icons.child_care_rounded,
                                    size: 50,
                                    color: cat.colorBase,
                                  ),
                            )
                          : Center(
                              child: Text(
                                cat.nombre.isNotEmpty
                                    ? cat.nombre.substring(0, 1).toUpperCase()
                                    : "?",
                                style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: cat.colorBase,
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    cat.nombre,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: cat.colorBase,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${cat.rutasDibujos.length} dibujos",
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(
                    Icons.delete_rounded,
                    color: Colors.red,
                    size: 24,
                  ),
                  onPressed: () => _eliminarCategoria(cat),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
