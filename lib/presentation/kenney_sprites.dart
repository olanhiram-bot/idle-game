import 'dart:ui';

/// Loaded CC0 sprites selected from Kenney's Toon Characters pack.
///
/// Actors from the pack face forward. Only close role matches are assigned;
/// the mage and original soot/enemy illustrations remain project-owned art.
abstract final class KenneySprites {
  static final Map<String, Image> _images = {};
  static int get imagesLoaded => _images.length;

  static String? hero(String id, int pose) {
    final character = switch (id) {
      'farol' => 'character_femaleAdventurer',
      'bastion' => 'character_maleAdventurer',
      _ => null,
    };
    if (character == null) return null;
    final state = switch (pose) {
      0 => 'idle',
      1 => 'attack0',
      2 => 'hurt',
      3 => 'down',
      _ => 'idle',
    };
    return '${character}_$state.png';
  }

  static Image? image(String path) => _images[path];
  static void install(String path, Image image) => _images[path] = image;
  static void clear() => _images.clear();

  static void paint(
    Canvas canvas,
    String path,
    Rect destination, {
    double opacity = 1,
  }) {
    final image = _images[path];
    if (image == null) return;
    final src = _trimmedSource(image, path);
    canvas.drawImageRect(
      image,
      src,
      destination,
      Paint()
        ..filterQuality = FilterQuality.medium
        ..color = Color.fromRGBO(255, 255, 255, opacity.clamp(0, 1)),
    );
  }

  // Per-pose alpha bounds trim the generous source margins without clipping.
  static Rect _trimmedSource(Image image, String path) {
    final bounds = switch (path) {
      'character_femaleAdventurer_idle.png' => const [32, 65, 160, 256],
      'character_femaleAdventurer_attack0.png' => const [17, 66, 183, 256],
      'character_femaleAdventurer_hurt.png' => const [1, 59, 187, 246],
      'character_femaleAdventurer_down.png' => const [15, 110, 188, 255],
      'character_maleAdventurer_idle.png' => const [29, 44, 163, 256],
      'character_maleAdventurer_attack0.png' => const [13, 49, 183, 256],
      'character_maleAdventurer_hurt.png' => const [1, 42, 187, 246],
      'character_maleAdventurer_down.png' => const [5, 84, 188, 256],
      _ => null,
    };
    if (bounds == null) {
      return Rect.fromLTWH(
        0,
        0,
        image.width.toDouble(),
        image.height.toDouble(),
      );
    }
    return Rect.fromLTRB(
      bounds[0].toDouble(),
      bounds[1].toDouble(),
      bounds[2].toDouble(),
      bounds[3].toDouble(),
    );
  }
}
