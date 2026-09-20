import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class CategoriaDinamica {
  final String nombre;
  final String
      rutaDirectorio; // 🚀 NUEVO: Necesario para poder eliminar la carpeta
  final String rutaPortada;
  final List<String> rutasDibujos;
  final Color colorBase;

  CategoriaDinamica({
    required this.nombre,
    required this.rutaDirectorio,
    required this.rutaPortada,
    required this.rutasDibujos,
    required this.colorBase,
  });
}

class GestorArchivos {
  static final List<Color> _colores = [
    Colors.orange,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.red,
    Colors.teal,
  ];

  static Future<void> importarArchivosDirectos() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg'],
        dialogTitle: 'Selecciona tus dibujos para colorear',
      );

      if (result != null) {
        final directorioRaiz = await getApplicationDocumentsDirectory();
        // Creamos una carpeta única usando la fecha para que no se sobreescriban
        final String nombreCarpetaUnica =
            "Pack_${DateTime.now().millisecondsSinceEpoch}";
        final directorioDestino = Directory(
          '${directorioRaiz.path}/MundoAlegria/$nombreCarpetaUnica',
        );

        if (!await directorioDestino.exists()) {
          await directorioDestino.create(recursive: true);
        }

        for (var file in result.files) {
          if (file.path != null) {
            final archivoOrigen = File(file.path!);
            final nombreArchivo = file.name;
            await archivoOrigen.copy(
              '${directorioDestino.path}/$nombreArchivo',
            );
          }
        }
      }
    } catch (e) {
      debugPrint("Error importando archivos: $e");
    }
  }

  static Future<List<CategoriaDinamica>> escanearCarpetasUsuario() async {
    List<CategoriaDinamica> categorias = [];

    try {
      final directorioRaiz = await getApplicationDocumentsDirectory();
      final directorioApp = Directory('${directorioRaiz.path}/MundoAlegria');

      if (!await directorioApp.exists()) {
        await directorioApp.create(recursive: true);
        return [];
      }

      final entidades = directorioApp.listSync();
      int colorIndex = 0;

      for (var entidad in entidades) {
        if (entidad is Directory) {
          final nombreCarpeta = entidad.path.split(Platform.pathSeparator).last;
          final archivos = entidad.listSync();

          String rutaPortada = "";
          List<String> rutasDibujos = [];

          for (var archivo in archivos) {
            if (archivo is File &&
                (archivo.path.toLowerCase().endsWith('.png') ||
                    archivo.path.toLowerCase().endsWith('.jpg') ||
                    archivo.path.toLowerCase().endsWith('.jpeg'))) {
              final nombreArchivo =
                  archivo.path.split(Platform.pathSeparator).last;
              if (nombreArchivo.toLowerCase().startsWith('portada.')) {
                rutaPortada = archivo.path;
              } else {
                rutasDibujos.add(archivo.path);
              }
            }
          }

          if (rutasDibujos.isNotEmpty) {
            categorias.add(
              CategoriaDinamica(
                nombre: nombreCarpeta.startsWith('Pack_')
                    ? "Mis Dibujos"
                    : nombreCarpeta,
                rutaDirectorio: entidad.path, // 🚀 Guardamos la ruta
                rutaPortada: rutaPortada,
                rutasDibujos: rutasDibujos,
                colorBase: _colores[colorIndex % _colores.length],
              ),
            );
            colorIndex++;
          }
        }
      }
    } catch (e) {
      debugPrint("Error escaneando carpetas: $e");
    }

    return categorias;
  }
}
