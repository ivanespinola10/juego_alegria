import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Servicio singleton para gestionar el audio ambiental y los efectos de sonido
class ServicioAudio {
  static final ServicioAudio instance = ServicioAudio._internal();
  ServicioAudio._internal();

  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _audioActivo = false;
  bool get audioActivo => _audioActivo;
  final ValueNotifier<bool> audioActivoNotifier = ValueNotifier<bool>(false);

  Future<void> cargarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    _audioActivo = prefs.getBool('audio_activo') ?? false;
    audioActivoNotifier.value = _audioActivo;
  }

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
      _musicaIniciada = false;
      debugPrint('Audio bg_music no disponible: $e');
    }
  }

  void playPop() {
    if (!_audioActivo) return;
    _sfxPlayer.play(AssetSource('audio/pop.mp3')).catchError((e) {
      debugPrint('Audio pop no disponible: $e');
    });
  }

  Future<void> toggleAudio() async {
    _audioActivo = !_audioActivo;
    audioActivoNotifier.value = _audioActivo;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('audio_activo', _audioActivo);
      if (_audioActivo) {
        if (!_musicaIniciada) await iniciarMusica();
        await _musicPlayer.resume();
      } else {
        await _musicPlayer.pause();
        await _sfxPlayer.stop();
      }
    } catch (e) {
      debugPrint('No se pudo cambiar el audio: $e');
    }
  }

  void pausarMusica() {
    _musicPlayer.pause();
  }

  void reanudarMusica() {
    if (_audioActivo) {
      _musicPlayer.resume();
    }
  }
}
