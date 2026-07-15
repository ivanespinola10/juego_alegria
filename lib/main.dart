import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'menu_principal.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Bloqueamos la app en modo horizontal (Landscape) como los juegos de Netflix
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(const AlegriaApp());
  });
}

class AlegriaApp extends StatelessWidget {
  const AlegriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'El Mundo de Alegría',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        // Si descargas una fuente como 'Fredoka' o 'ComicSans', agrégala aquí
      ),
      home: const MenuPrincipal(),
    );
  }
}
