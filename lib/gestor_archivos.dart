import 'package:file_picker/file_picker.dart';

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class ResultadoImportacion {
  final int importados;
  final int omitidos;
  const ResultadoImportacion(this.importados, this.omitidos);
}

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

  // Limits apply to each batch/image, never to the paid library's total size.
  static const maxBytes = 20 * 1024 * 1024;
  static const maxPixels = 40000000;
  static const maxLado = 2048;

  static Future<ResultadoImportacion> importarArchivosDirectos({
    bool multiple = true,
  }) async {
    int importados = 0;
    int omitidos = 0;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: multiple,
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

      final seleccion = result.files.take(multiple ? 20 : 1);
      omitidos = result.files.length - seleccion.length;
      for (var file in seleccion) {
        ui.ImmutableBuffer? buffer;
        ui.ImageDescriptor? descriptor;
        ui.Codec? codec;
        ui.Image? imagen;
        try {
          if (file.path == null) throw const FormatException('No path');
          final origen = File(file.path!);
          final bytes = await origen.length();
          if (bytes == 0 || bytes > maxBytes) {
            throw const FormatException('Image exceeds byte limit');
          }
          buffer = await ui.ImmutableBuffer.fromUint8List(
            await origen.readAsBytes(),
          );
          descriptor = await ui.ImageDescriptor.encoded(buffer);
          if (descriptor.width * descriptor.height > maxPixels) {
            throw const FormatException('Image exceeds pixel limit');
          }
          final lado = descriptor.width > descriptor.height
              ? descriptor.width
              : descriptor.height;
          final escala = lado > maxLado ? maxLado / lado : 1.0;
          codec = await descriptor.instantiateCodec(
            targetWidth: (descriptor.width * escala).round().clamp(1, maxLado),
            targetHeight: (descriptor.height * escala).round().clamp(
              1,
              maxLado,
            ),
          );
          imagen = (await codec.getNextFrame()).image;
          final png = await imagen.toByteData(format: ui.ImageByteFormat.png);
          if (png == null) {
            throw const FormatException('Unable to encode image');
          }
          // Generated names avoid collisions and untrusted source paths.
          await File('${directorioDestino.path}/lamina_$importados.png')
              .writeAsBytes(png.buffer.asUint8List(), flush: true);
          importados++;
        } catch (_) {
          omitidos++;
        } finally {
          imagen?.dispose();
          codec?.dispose();
          descriptor?.dispose();
          buffer?.dispose();
        }
      }
      if (importados == 0 && await directorioDestino.exists()) {
        // Only remove the empty directory created by this operation.
        if (await directorioDestino.list().isEmpty) {
          await directorioDestino.delete();
        }
      }
    }
    return ResultadoImportacion(importados, omitidos);
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

      final entidades = await directorioApp.list(followLinks: false).toList();
      entidades.sort((a, b) => a.path.compareTo(b.path));
      int colorIndex = 0;

      for (var entidad in entidades) {
        if (entidad is Directory) {
          final nombreCarpeta = entidad.path.split(Platform.pathSeparator).last;
          final archivos = await entidad.list(followLinks: false).toList();
          archivos.sort((a, b) => a.path.compareTo(b.path));

          String rutaPortada = "";
          List<String> rutasDibujos = [];

          for (var archivo in archivos) {
            if (archivo is File &&
                (archivo.path.toLowerCase().endsWith('.png') ||
                    archivo.path.toLowerCase().endsWith('.jpg') ||
                    archivo.path.toLowerCase().endsWith('.jpeg'))) {
              final nombreArchivo = archivo.path
                  .split(Platform.pathSeparator)
                  .last;
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
