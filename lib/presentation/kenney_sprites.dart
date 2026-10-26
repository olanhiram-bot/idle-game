import 'dart:ui';

import 'package:flame/cache.dart';
import 'package:flutter/foundation.dart';

/// Shared, bounded app-lifetime cache. Views never dispose another view's art.
abstract final class KenneySprites {
  static const characters = [
    'femaleAdventurer',
    'maleAdventurer',
    'femalePerson',
    'malePerson',
    'zombie',
    'robot',
  ];
  static const poses = ['idle', 'attack0', 'attack1', 'hurt', 'down', 'duck'];
  static final _assets = Images(prefix: 'assets/toon/');
  static final Map<String, Image> _images = {};
  static Future<void>? _loading;
  static final revision = ValueNotifier<int>(0);
  static int get imagesLoaded => _images.length;

  static Future<void> load() => _loading ??= _load();
  static Future<void> _load() async {
    try {
      for (final character in characters) {
        for (final pose in poses) {
          final file = 'character_${character}_$pose.png';
          _images[file] = await _assets.load(file);
        }
      }
      revision.value++;
    } catch (_) {
      _loading = null;
      rethrow;
    }
  }

  static String? hero(String id, int pose) {
    final character = switch (id) {
      'farol' => 'femaleAdventurer',
      'bastion' => 'maleAdventurer',
      'ascua' => 'femalePerson',
      'vigia' => 'malePerson',
      _ => null,
    };
    return character == null ? null : file(character, pose);
  }

  static String file(String character, int pose) {
    final state = switch (pose) {
      1 => 'attack0',
      2 => 'hurt',
      3 => 'down',
      4 => 'duck',
      5 => 'attack1',
      _ => 'idle',
    };
    return 'character_${character}_$state.png';
  }

  static String enemy(int kind, int pose) =>
      file(kind == 1 || kind == 3 ? 'robot' : 'zombie', pose);

  static Image? image(String path) => _images[path];
  static void install(String path, Image image) => _images[path] = image;

  /// Test reset only; runtime cache remains bounded to the six actors.
  static void clear() {
    _images.clear();
    _assets.clearCache();
    _loading = null;
    revision.value++;
  }

  static void paint(
    Canvas canvas,
    String path,
    Rect destination, {
    double opacity = 1,
  }) {
    final image = _images[path];
    if (image == null) return;
    // Use the full aligned pose canvas, uniform scaling and bottom anchoring.
    // Per-pose trimming would change body proportions and make feet jump.
    final scale =
        (destination.width / image.width) < (destination.height / image.height)
        ? destination.width / image.width
        : destination.height / image.height;
    final w = image.width * scale, h = image.height * scale;
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(
        destination.center.dx - w / 2,
        destination.bottom - h,
        w,
        h,
      ),
      Paint()
        ..filterQuality = FilterQuality.medium
        ..color = Color.fromRGBO(255, 255, 255, opacity.clamp(0, 1)),
    );
  }
}
