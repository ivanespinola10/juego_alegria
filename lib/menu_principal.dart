import 'dart:io';
import 'dart:math'; // 🚀 NECESARIO PARA LA COMPUERTA PARENTAL
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'idiomas.dart'; // 🚀 TRADUCTOR CONECTADO
import 'gestor_archivos.dart';
import 'juego_pintura.dart';
import 'servicio_audio.dart';
import 'iap_service.dart'; // 🚀 IAP CONECTADO PARA PRODUCCIÓN

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({super.key});

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  List<CategoriaDinamica> _categoriasUsuario = [];
  bool _cargando = true;

  // 🚀 NUEVA LISTA DE PACKS DE FÁBRICA
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
      "subtitulo": "Amigos",
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
    _cargarCarpetas();
    ServicioAudio.instance.iniciarMusica();
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
    setState(() {
      _categoriasUsuario = carpetas;
      _cargando = false;
    });
  }

  void _eliminarCategoria(CategoriaDinamica cat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          Traductor.get('borrar_pack'),
          style:
              const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        content: Text(Traductor.get('borrar_aviso')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(Traductor.get('cancelar')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              final directorio = Directory(cat.rutaDirectorio);
              if (directorio.existsSync()) {
                directorio.deleteSync(recursive: true);
                _cargarCarpetas();
              }
            },
            child: Text(Traductor.get('si_borrar')),
          ),
        ],
      ),
    );
  }

  // 🚀 COMPUERTA PARENTAL (Seguridad exigida por Google)
  void _mostrarCompuertaParental() {
    ServicioAudio.instance.playPop();
    final Random rand = Random();
    final int num1 = rand.nextInt(10) + 5;
    final int num2 = rand.nextInt(10) + 5;
    final int respuestaCorrecta = num1 + num2;
    final TextEditingController ctrl = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Center(
            child: Column(
              children: [
                Icon(Icons.lock_rounded, size: 40, color: Colors.grey),
                SizedBox(height: 10),
                Text("Zona de Padres",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  "Pide ayuda a un adulto.\nPara continuar, resuelve la suma:",
                  textAlign: TextAlign.center),
              const SizedBox(height: 15),
              Text("$num1 + $num2 = ?",
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple)),
              const SizedBox(height: 15),
              TextField(
                controller: ctrl,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: "Respuesta",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text("Cancelar", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {
                if (ctrl.text.trim() == respuestaCorrecta.toString()) {
                  Navigator.pop(context); // Cierra la compuerta
                  _mostrarMenuAjustesPadres(); // Abre ajustes reales
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Respuesta incorrecta.'),
                        backgroundColor: Colors.red),
                  );
                }
              },
              child: const Text("Comprobar",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // 🚀 MENÚ DE AJUSTES PREMIUM
  void _mostrarMenuAjustesPadres() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Ajustes Premium",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.restore_rounded,
                    color: Colors.green, size: 30),
                title: const Text("Restaurar Compras",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text("Si cambiaste de celular"),
                onTap: () {
                  Navigator.pop(context);
                  // 🚀 RESTAURAR COMPRAS VÍA GOOGLE PLAY BILLING
                  IAPService().restorePurchases();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Restaurando compras conectando a Google Play...'),
                        backgroundColor: Colors.green),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.privacy_tip_rounded,
                    color: Colors.blue, size: 30),
                title: const Text("Política de Privacidad"),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Abriendo política de privacidad...')),
                  );
                },
              ),
            ],
          ),
        );
      },
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
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.auto_awesome_rounded,
                            color: Colors.amber, size: 28),
                        SizedBox(width: 8),
                        Text(
                          "El Mundo de Alegría",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.settings,
                              color: Colors.deepPurple, size: 28),
                          onPressed: _mostrarCompuertaParental,
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable:
                              ServicioAudio.instance.audioActivoNotifier,
                          builder: (context, audioActivo, _) {
                            return IconButton(
                              icon: Icon(
                                audioActivo
                                    ? Icons.volume_up_rounded
                                    : Icons.volume_off_rounded,
                                color: audioActivo
                                    ? Colors.deepPurple
                                    : Colors.grey,
                                size: 28,
                              ),
                              onPressed: () {
                                ServicioAudio.instance.playPop();
                                ServicioAudio.instance.toggleAudio();
                              },
                            );
                          },
                        ),
                        if (!kIsWeb)
                          IconButton(
                            icon: const Icon(Icons.refresh_rounded,
                                color: Colors.deepPurple, size: 28),
                            onPressed: () {
                              ServicioAudio.instance.playPop();
                              _cargarCarpetas();
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _cargando
                    ? const Center(child: CircularProgressIndicator())
                    : Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ..._packsEstaticos.map((pack) =>
                                  _buildTarjetaEstatica(context, pack)),
                              ..._categoriasUsuario.map(
                                  (cat) => _buildTarjetaDinamica(context, cat)),
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
      BuildContext context, Map<String, dynamic> pack) {
    final Color colorMascota = pack["color"];
    final IconData iconoData =
        pack["icono"] is IconData ? pack["icono"] : Icons.menu_book_rounded;

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
                color: colorMascota.withValues(alpha: 0.3), width: 3),
            boxShadow: [
              BoxShadow(
                  color: colorMascota.withValues(alpha: 0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 8))
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: colorMascota.withValues(alpha: 0.1),
                    shape: BoxShape.circle),
                child: Icon(iconoData, size: 60, color: colorMascota),
              ),
              const SizedBox(height: 20),
              Text(
                pack["titulo"],
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colorMascota),
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
                color: cat.colorBase.withValues(alpha: 0.3), width: 3),
            boxShadow: [
              BoxShadow(
                  color: cat.colorBase.withValues(alpha: 0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 8))
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
                        shape: BoxShape.circle),
                    child: ClipOval(
                      child: cat.rutaPortada.isNotEmpty
                          ? Image.file(File(cat.rutaPortada),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.child_care_rounded,
                                      size: 50, color: cat.colorBase))
                          : Center(
                              child: Text(
                                cat.nombre.isNotEmpty
                                    ? cat.nombre.substring(0, 1).toUpperCase()
                                    : "?",
                                style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    color: cat.colorBase),
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
                        color: cat.colorBase),
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
                  icon: const Icon(Icons.delete_rounded,
                      color: Colors.red, size: 24),
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
