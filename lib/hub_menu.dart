import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'menu_principal.dart'; // Módulo actual de pintura
import 'trial_manager.dart'; // Para ParentalGateScreen

class HubMenu extends StatefulWidget {
  const HubMenu({super.key});

  @override
  State<HubMenu> createState() => _HubMenuState();
}

class _HubMenuState extends State<HubMenu> {
  bool _isMuted = false;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    _iniciarMusica();
  }

  Future<void> _iniciarMusica() async {
    try {
      if (!_isMuted) {
        await _audioPlayer.play(AssetSource('audio/bg_music.mp3'));
      }
    } catch (e) {
      debugPrint("Error al reproducir audio: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDD0),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '¡Hola! ¿A qué jugamos hoy?',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7A7A7A),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 32,
                      mainAxisSpacing: 32,
                      childAspectRatio: 1.6,
                      children: [
                        _buildGameCard(
                          context: context,
                          title: 'Pintura',
                          icon: Icons.palette_rounded,
                          color: const Color(0xFFFFB7B2), // Rojo/rosa pastel
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MenuPrincipal()),
                            );
                          },
                        ),
                        _buildGameCard(
                          context: context,
                          title: 'Rompecabezas\n(Próximamente)',
                          icon: Icons.extension_rounded,
                          color: const Color(0xFFB5EAD7), // Verde pastel
                          isComingSoon: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ParentalGateScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 32,
              right: 32,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isMuted = !_isMuted;
                    if (_isMuted) {
                      _audioPlayer.pause();
                    } else {
                      _audioPlayer.resume();
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                    color: const Color(0xFF7A7A7A),
                    size: 32,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isComingSoon = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 80,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            if (isComingSoon)
              Positioned(
                top: 24,
                right: 24,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.lock_rounded, color: Colors.white, size: 28),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
