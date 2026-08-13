import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

/// Servicio singleton para gestionar el audio ambiental y los efectos de sonido
class ServicioAudio {
  static final ServicioAudio instance = ServicioAudio._internal();
  ServicioAudio._internal();

  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _audioActivo = true;
  bool get audioActivo => _audioActivo;
  final ValueNotifier<bool> audioActivoNotifier = ValueNotifier<bool>(true);

  bool _musicaIniciada = false;

  Future<void> iniciarMusica() async {
    if (_musicaIniciada) return;
    _musicaIniciada = true;
    try {
      await _musicPlayer.setSource(AssetSource('audio/bg_music.mp3'));
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.setVolume(0.3);
      if (_audioActivo) {
        await _musicPlayer.resume();
      }
    } catch (e) {
      debugPrint('Audio bg_music no disponible: $e');
    }
  }

  void playPop() {
    if (!_audioActivo) return;
    _sfxPlayer.play(AssetSource('audio/pop.mp3')).catchError((e) {
      debugPrint('Audio pop no disponible: $e');
    });
  }

  void toggleAudio() {
    _audioActivo = !_audioActivo;
    audioActivoNotifier.value = _audioActivo;
    if (_audioActivo) {
      _musicPlayer.resume();
    } else {
      _musicPlayer.pause();
    }
  }
}
