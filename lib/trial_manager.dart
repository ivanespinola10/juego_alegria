import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'iap_service.dart';

class ParentalGateScreen extends StatefulWidget {
  const ParentalGateScreen({super.key});

  @override
  State<ParentalGateScreen> createState() => _ParentalGateScreenState();
}

class _ParentalGateScreenState extends State<ParentalGateScreen> {
  late int num1;
  late int num2;
  final TextEditingController _answerController = TextEditingController();
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _generateMathProblem();
  }

  void _generateMathProblem() {
    final random = Random();
    num1 = random.nextInt(10) + 1;
    num2 = random.nextInt(10) + 1;
  }

  void _checkAnswer() {
    final int? answer = int.tryParse(_answerController.text.trim());
    if (answer != null && answer == (num1 + num2)) {
      // Respuesta correcta, avanzar a la pantalla premium
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const PremiumPaymentScreen()),
      );
    } else {
      setState(() {
        _errorMessage = 'Respuesta incorrecta. Inténtalo de nuevo.';
        _answerController.clear();
        _generateMathProblem();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5), // Rosa pastel suave
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_rounded, size: 64, color: Color(0xFFD3D3D3)),
                const SizedBox(height: 16),
                const Text(
                  '¡Fin de la prueba!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7A7A7A),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Pide ayuda a un adulto.\nPara continuar, resuelve la suma:',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Color(0xFF909090)),
                ),
                const SizedBox(height: 24),
                Text(
                  '$num1 + $num2 = ?',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5A5A5A),
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _answerController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, color: Color(0xFF5A5A5A)),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFD3D3D3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFAEC6CF)),
                    ),
                    hintText: 'Respuesta',
                    hintStyle: const TextStyle(color: Color(0xFFD3D3D3)),
                  ),
                ),
                if (_errorMessage.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage,
                    style: const TextStyle(color: Color(0xFFFFB7B2), fontSize: 16),
                  ),
                ],
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _checkAnswer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFAEC6CF), // Azul pastel
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Comprobar',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PremiumPaymentScreen extends StatefulWidget {
  const PremiumPaymentScreen({super.key});

  @override
  State<PremiumPaymentScreen> createState() => _PremiumPaymentScreenState();
}

class _PremiumPaymentScreenState extends State<PremiumPaymentScreen> {
  @override
  void initState() {
    super.initState();
    IAPService().init();
    IAPService().addListener(_onIapChanged);
  }

  void _onIapChanged() {
    if (IAPService().isPremium && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Compra exitosa! Contenido desbloqueado.'),
          backgroundColor: Colors.green,
        ),
      );
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    IAPService().removeListener(_onIapChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iap = IAPService();
    String price = "Cargando precio...";
    if (iap.products.isNotEmpty) {
      price = iap.products.first.price;
    } else if (!iap.isAvailable) {
      price = "Tienda no disponible";
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE6E6FA), // Lavanda pastel
      appBar: AppBar(
        title: const Text('Área para Padres - Premium', style: TextStyle(color: Color(0xFF5A5A5A))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF5A5A5A)),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded, size: 80, color: Color(0xFFFFDFBA)), // Naranja/amarillo pastel
              const SizedBox(height: 24),
              const Text(
                'Desbloquea todo el contenido',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7A7A7A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Precio: $price',
                style: const TextStyle(fontSize: 18, color: Color(0xFF909090)),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: (iap.products.isNotEmpty || !kReleaseMode) ? () {
                  iap.buyPremium();
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB7B2), // Rosa pastel
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Comprar ahora', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  iap.restorePurchases();
                },
                child: const Text('Restaurar compras', style: TextStyle(color: Color(0xFF7A7A7A))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

