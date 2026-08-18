import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'menu_principal.dart'; // 🚀 VOLVEMOS AL MENÚ PRINCIPAL DIRECTO

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      ),
      home: const MenuPrincipal(), // 🚀 LA PORTADA VUELVE A SER EL MENÚ
    );
  }
}
