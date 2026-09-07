import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'textos_adultos.dart';

/// A friction barrier for young children, not identity/age verification and not
/// a replacement for the store's purchase authentication.
Future<bool> solicitarAdulto(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (_) => const _ConfirmacionAdulto(),
      ) ??
      false;
}

class _ConfirmacionAdulto extends StatefulWidget {
  const _ConfirmacionAdulto();
  @override
  State<_ConfirmacionAdulto> createState() => _ConfirmacionAdultoState();
}

class _ConfirmacionAdultoState extends State<_ConfirmacionAdulto> {
  final _entrada = TextEditingController();
  final int _a = 12 + Random().nextInt(18);
  final int _b = 11 + Random().nextInt(19);
  @override
  void dispose() {
    _entrada.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    scrollable: true,
    title: Text(textoAdulto('adults')),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(textoAdulto('gate')),
        Text('$_a + $_b = ?', style: const TextStyle(fontSize: 24)),
        TextField(
          controller: _entrada,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 3,
          decoration: InputDecoration(labelText: textoAdulto('gate')),
          onChanged: (_) => setState(() {}),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: Text(textoAdulto('cancel')),
      ),
      TextButton(
        onPressed: int.tryParse(_entrada.text) == _a + _b
            ? () => Navigator.pop(context, true)
            : null,
        child: Text(textoAdulto('continue')),
      ),
    ],
  );
}
