import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 🚀 Nuevo
import 'menu_principal.dart';
import 'idiomas.dart';
import 'onboarding.dart'; // 🚀 Nuevo

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Traductor.inicializar();

  // 🚀 Verificamos si es la primera vez
  final prefs = await SharedPreferences.getInstance();
  final bool vioOnboarding = prefs.getBool('vio_onboarding') ?? false;

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    // 🚀 Le pasamos el resultado a la App
    runApp(AlegriaApp(mostrarOnboarding: !vioOnboarding));
  });
}

class AlegriaApp extends StatelessWidget {
  final bool mostrarOnboarding;

  const AlegriaApp({super.key, required this.mostrarOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'El Mundo de Alegría',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Nunito',
      ),
      // 🚀 Si es la primera vez, muestra el Onboarding. Si no, va al Menú.
      home: mostrarOnboarding
          ? const PantallaOnboarding()
          : const MenuPrincipal(),
    );
  }
}
