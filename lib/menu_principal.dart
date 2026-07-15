import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'idiomas.dart'; // 🚀 TRADUCTOR CONECTADO
import 'gestor_archivos.dart';
import 'juego_pintura.dart';

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({super.key});

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  List<CategoriaDinamica> _categoriasUsuario = [];
  bool _cargando = true;

  // 🚀 LISTA DE PACKS DE FÁBRICA
  final List<Map<String, dynamic>> _packsEstaticos = [
    {
      "titulo": "Moisés",
      "subtitulo": "Historias",
      "icono": "📜",
      "color": Colors.orange,
      "archivos": [
        "assets/canva/1.png",
        "assets/canva/2.png",
        "assets/canva/3.png",
        "assets/canva/4.png",
        "assets/canva/5.png",
        "assets/canva/6.png",
        "assets/canva/7.png",
        "assets/canva/8.png",
        "assets/canva/9.png",
        "assets/canva/10.png",
      ],
    },

    {
      "titulo": "Abecedario",
      "subtitulo": "Aprende las Letras",
      "icono": "🔤",
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
    _cargarCarpetas(); // 🚀 Carga directamente porque ya es versión de PAGO
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
          Traductor.get('borrar_pack') ?? "¿Borrar este pack?",
          style:
              const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        content: Text(Traductor.get('borrar_aviso') ??
            "Se eliminarán todos los dibujos de esta carpeta. ¡No se puede deshacer!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(Traductor.get('cancelar') ?? "Cancelar"),
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
            child: Text(Traductor.get('si_borrar') ?? "Sí, borrar"),
          ),
        ],
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
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 8),
                        const Text(
                          "✨ El Mundo de Alegría",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple),
                        ),
                      ],
                    ),
                    if (!kIsWeb)
                      IconButton(
                        icon: const Icon(Icons.refresh_rounded,
                            color: Colors.deepPurple, size: 28),
                        onPressed: _cargarCarpetas,
                      ),
                  ],
                ),
              ),
              Expanded(
                child: _cargando
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        children: [
                          ..._packsEstaticos.map(
                              (pack) => _buildTarjetaEstatica(context, pack)),
                          ..._categoriasUsuario.map(
                              (cat) => _buildTarjetaDinamica(context, cat)),
                          _buildTarjetaComercial(),
                        ],
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
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JuegoPintura(
            dibujos: List<String>.from(pack["archivos"]),
            titulo: pack["titulo"],
            colorBase: colorMascota,
            esNativo: false,
          ),
        ),
      ),
      child: Container(
        width: 240,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: colorMascota.withOpacity(0.3), width: 3),
          boxShadow: [
            BoxShadow(
                color: colorMascota.withOpacity(0.15),
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
                  color: colorMascota.withOpacity(0.1), shape: BoxShape.circle),
              child: Text(pack["icono"], style: const TextStyle(fontSize: 65)),
            ),
            const SizedBox(height: 20),
            Text(pack["titulo"],
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colorMascota)),
            Text(pack["subtitulo"],
                style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildTarjetaDinamica(BuildContext context, CategoriaDinamica cat) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JuegoPintura(
                dibujos: cat.rutasDibujos,
                titulo: cat.nombre,
                colorBase: cat.colorBase,
                esNativo: true,
              ),
            ),
          ),
          child: Container(
            width: 240,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border:
                  Border.all(color: cat.colorBase.withOpacity(0.3), width: 3),
              boxShadow: [
                BoxShadow(
                    color: cat.colorBase.withOpacity(0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 8))
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                      color: cat.colorBase.withOpacity(0.1),
                      shape: BoxShape.circle),
                  child: ClipOval(
                    child: cat.rutaPortada.isNotEmpty
                        ? Image.file(File(cat.rutaPortada), fit: BoxFit.cover)
                        : Center(
                            child: Text(
                              cat.nombre.substring(0, 1).toUpperCase(),
                              style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: cat.colorBase),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(cat.nombre,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: cat.colorBase)),
                Text("${cat.rutasDibujos.length} dibujos",
                    style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),
        ),
        Positioned(
          top: 15,
          right: 15,
          child: GestureDetector(
            onTap: () => _eliminarCategoria(cat),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.red.shade100, shape: BoxShape.circle),
              child:
                  const Icon(Icons.delete_rounded, color: Colors.red, size: 24),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTarjetaComercial() {
    return GestureDetector(
      onTap: () async {
        // 🚀 YA NO HAY MURO DE PAGO, ABRE LOS ARCHIVOS DIRECTO
        await GestorArchivos.importarArchivosDirectos();
        _cargarCarpetas();
      },
      child: Container(
        width: 240,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.purple.shade50.withOpacity(0.5),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.purple.shade100, width: 2.5),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_photo_alternate_rounded,
                      size: 50, color: Colors.purple),
                  const SizedBox(height: 10),
                  Text(
                    Traductor.get('importar'), // "Importar Dibujos"
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Traductor.get('importar_desc') ??
                        "Desde tu equipo",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
