import 'dart:math';

import 'package:flutter/material.dart';

import 'idiomas.dart';

/// Compuerta simple para acciones destinadas a adultos, como compras o compartir.
Future<bool> solicitarConfirmacionAdulto(BuildContext context) async {
  final random = Random();
  final a = 6 + random.nextInt(5);
  final b = 4 + random.nextInt(6);
  final respuesta = a * b;
  final controller = TextEditingController();
  String? error;

  final resultado = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Row(
            children: [
              const Icon(Icons.lock_outline_rounded,
                  color: Colors.deepPurple),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  Traductor.get('solo_adultos'),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Traductor.get('pregunta_adulto'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  '$a × $b = ?',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: Traductor.get('respuesta'),
                    errorText: error,
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onSubmitted: (_) {
                    final valor = int.tryParse(controller.text.trim());
                    if (valor == respuesta) {
                      Navigator.pop(dialogContext, true);
                    } else {
                      setDialogState(() {
                        error = Traductor.get('respuesta_incorrecta');
                        controller.clear();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(Traductor.get('cancelar')),
            ),
            FilledButton(
              onPressed: () {
                final valor = int.tryParse(controller.text.trim());
                if (valor == respuesta) {
                  Navigator.pop(dialogContext, true);
                } else {
                  setDialogState(() {
                    error = Traductor.get('respuesta_incorrecta');
                    controller.clear();
                  });
                }
              },
              child: Text(Traductor.get('comprobar')),
            ),
          ],
        );
      },
    ),
  );

  controller.dispose();
  return resultado ?? false;
}
