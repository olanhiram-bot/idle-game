import 'dart:async';

import 'package:flame_audio/flame_audio.dart';

/// Un solo canal: no se acumulan voces ni partículas de audio.
class GameSound {
  final AudioPlayer player = AudioPlayer();
  bool _busy = false;
  Future<void> play(String name) async {
    if (_busy) return;
    _busy = true;
    try {
      await player.stop();
      await player.play(AssetSource('audio/$name.wav'), volume: .35);
    } catch (_) {
      /* El audio opcional nunca bloquea la partida. */
    } finally {
      _busy = false;
    }
  }

  Future<void> stop() => player.stop();
  Future<void> dispose() => player.dispose();
}
