import 'dart:ui';

import 'package:flame/cache.dart';
import 'package:flame/game.dart';

/// Artist-facing preview of selected CC0 sprites, also opened from combat HUD.
class KenneyAssetGallery extends FlameGame {
  KenneyAssetGallery();

  final Map<String, Image> _sprites = {};
  late final Images _assetImages = Images(prefix: 'assets/third_party/kenney/');
  int get imagesLoaded => _sprites.length;
  Future<void> get assetsLoaded => loaded;

  static const _assets = <(String, String)>[
    (
      'HEROÍNA · IDLE',
      'toon-characters/selected/Female adventurer/PNG/Poses HD/character_femaleAdventurer_idle.png',
    ),
    (
      'HEROÍNA · ATAQUE',
      'toon-characters/selected/Female adventurer/PNG/Poses HD/character_femaleAdventurer_attack0.png',
    ),
    (
      'HÉROE · IDLE',
      'toon-characters/selected/Male adventurer/PNG/Poses HD/character_maleAdventurer_idle.png',
    ),
    (
      'HÉROE · ATAQUE',
      'toon-characters/selected/Male adventurer/PNG/Poses HD/character_maleAdventurer_attack0.png',
    ),
    (
      'ZOMBI · IDLE',
      'toon-characters/selected/Zombie/PNG/Poses HD/character_zombie_idle.png',
    ),
    (
      'ZOMBI · ATAQUE',
      'toon-characters/selected/Zombie/PNG/Poses HD/character_zombie_attack0.png',
    ),
    (
      'ZOMBI · DAÑO',
      'toon-characters/selected/Zombie/PNG/Poses HD/character_zombie_hurt.png',
    ),
    (
      'ZOMBI · CAÍDA',
      'toon-characters/selected/Zombie/PNG/Poses HD/character_zombie_down.png',
    ),
    (
      'HEROÍNA · DAÑO',
      'toon-characters/selected/Female adventurer/PNG/Poses HD/character_femaleAdventurer_hurt.png',
    ),
    (
      'HEROÍNA · DERROTA',
      'toon-characters/selected/Female adventurer/PNG/Poses HD/character_femaleAdventurer_down.png',
    ),
    ('SUELO · PIEDRA 128', 'rpg-base/selected/rpgTile128.png'),
    ('SUELO · PIEDRA 132', 'rpg-base/selected/rpgTile132.png'),
    ('SUELO · PIEDRA 134', 'rpg-base/selected/rpgTile134.png'),
  ];
  @override
  Future<void> onLoad() async {
    for (final (label, asset) in _assets) {
      _sprites[label] = await _assetImages.load(asset);
    }
  }

  @override
  Color backgroundColor() => const Color(0xFF101820);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final columns = size.x < 480 ? 3 : 4;
    final rows = (_assets.length / columns).ceil();
    final cellWidth = size.x / columns;
    final cellHeight = size.y / rows;
    final p = Paint()..isAntiAlias = true;
    for (var index = 0; index < _assets.length; index++) {
      final (label, _) = _assets[index];
      final col = index % columns;
      final row = index ~/ columns;
      final cell = Rect.fromLTWH(
        col * cellWidth + 8,
        row * cellHeight + 8,
        cellWidth - 16,
        cellHeight - 16,
      );
      final card = RRect.fromRectAndRadius(cell, const Radius.circular(12));
      canvas.drawRRect(card, Paint()..color = const Color(0xFF202B36));
      canvas.drawRRect(
        card,
        Paint()
          ..color = const Color(0xFF435263)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );
      final image = _sprites[label];
      if (image == null) continue;
      const padding = 12.0;
      final spriteBounds = Rect.fromLTWH(
        cell.left + padding,
        cell.top + padding,
        cell.width - padding * 2,
        cell.height - 42,
      );
      // Preserve sprite aspect ratio and transparent margins.
      final ratio = image.width / image.height;
      final width = spriteBounds.width < spriteBounds.height * ratio
          ? spriteBounds.width
          : spriteBounds.height * ratio;
      final height = width / ratio;
      final destination = Rect.fromLTWH(
        spriteBounds.center.dx - width / 2,
        spriteBounds.center.dy - height / 2,
        width,
        height,
      );
      canvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        destination,
        p,
      );
      final builder =
          ParagraphBuilder(
              ParagraphStyle(
                textAlign: TextAlign.center,
                fontSize: size.y < 220 ? 9 : 12,
                fontWeight: FontWeight.w800,
              ),
            )
            ..pushStyle(TextStyle(color: const Color(0xFFE8D7B8)))
            ..addText(label);
      final paragraph = builder.build()
        ..layout(ParagraphConstraints(width: cell.width - 8));
      canvas.drawParagraph(
        paragraph,
        Offset(cell.left + 4, cell.bottom - paragraph.height - 10),
      );
    }
  }

  @override
  void onRemove() {
    _assetImages.clearCache();
    _sprites.clear();

    super.onRemove();
  }
}
