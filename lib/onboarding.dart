import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'menu_principal.dart';
import 'idiomas.dart';

class PantallaOnboarding extends StatefulWidget {
  const PantallaOnboarding({super.key});

  @override
  State<PantallaOnboarding> createState() => _PantallaOnboardingState();
}

class _PantallaOnboardingState extends State<PantallaOnboarding> {
  final PageController _controlador = PageController();
  int _paginaActual = 0;

  void _finalizarOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vio_onboarding', true);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MenuPrincipal()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: _controlador,
            onPageChanged: (index) => setState(() => _paginaActual = index),
            children: [
              _construirPagina(
                icono: Icons.format_color_fill_rounded,
                color: Colors.blue,
                titulo: Traductor.get('onb_titulo_1'),
                descripcion: Traductor.get('onb_desc_1'),
              ),
              _construirPagina(
                icono: Icons.science_rounded,
                color: Colors.purple,
                titulo: Traductor.get('onb_titulo_2'),
                descripcion: Traductor.get('onb_desc_2'),
              ),
              _construirPagina(
                icono: Icons.add_photo_alternate_rounded,
                color: Colors.orange,
                titulo: Traductor.get('onb_titulo_3'),
                descripcion: Traductor.get('onb_desc_3'),
              ),
            ],
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(
                    3,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 10,
                      width: _paginaActual == index ? 25 : 10,
                      decoration: BoxDecoration(
                        color: _paginaActual == index
                            ? Colors.deepPurple
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    elevation: 5,
                  ),
                  onPressed: () {
                    if (_paginaActual == 2) {
                      _finalizarOnboarding();
                    } else {
                      _controlador.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut);
                    }
                  },
                  child: Text(
                    _paginaActual == 2 ? Traductor.get('onb_boton') : "➡️",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirPagina(
      {required IconData icono,
      required Color color,
      required String titulo,
      required String descripcion}) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icono, size: 100, color: color),
          ),
          const SizedBox(height: 40),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800),
          ),
          const SizedBox(height: 20),
          Text(
            descripcion,
            textAlign: TextAlign.center,
            style:
                const TextStyle(fontSize: 18, color: Colors.grey, height: 1.5),
          ),
        ],
      ),
    );
  }
}
