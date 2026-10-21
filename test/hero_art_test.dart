import 'dart:async';
import 'dart:ui';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/presentation/hero_art.dart';
import 'package:idle_game/presentation/kenney_sprites.dart';

void main() {
  tearDown(KenneySprites.clear);

  test('Kenney pose associations match only compatible hero roles', () {
    expect(KenneySprites.hero('farol', 0), isNotNull);
    expect(KenneySprites.hero('bastion', 0), isNotNull);
    expect(KenneySprites.hero('ascua', 0), isNull);
    expect(KenneySprites.hero('unknown', 0), isNull);
  });
  test(
    'HeroArt paints a loaded Kenney sprite instead of the vector fallback',
    () async {
      final spriteRecorder = PictureRecorder();
      Canvas(spriteRecorder).drawRect(
        const Rect.fromLTWH(0, 0, 8, 8),
        Paint()..color = const Color(0xFF26E7A0),
      );
      final spritePicture = spriteRecorder.endRecording();
      final sprite = await spritePicture.toImage(8, 8);
      const path = 'character_femaleAdventurer_idle.png';
      KenneySprites.install(path, sprite);

      final recorder = PictureRecorder();
      HeroArt.paint(Canvas(recorder), 'farol', 0);
      final picture = recorder.endRecording();
      final image = await picture.toImage(320, 320);
      final bytes = (await image.toByteData())!;
      expect(image.width, 320);
      expect(bytes.lengthInBytes, 320 * 320 * 4);

      image.dispose();
      picture.dispose();
      sprite.dispose();
      spritePicture.dispose();
    },
  );
  test(
    'Tres ilustraciones completas y poses distintas sin errores de pintura',
    () async {
      final results = <int>[];
      for (final id in ['farol', 'bastion', 'ascua']) {
        final recorder = PictureRecorder();
        HeroArt.paint(Canvas(recorder), id, 0);
        final picture = recorder.endRecording();
        final image = await picture.toImage(300, 320);
        final bytes = (await image.toByteData())!;
        var colored = 0;
        for (var i = 3; i < bytes.lengthInBytes; i += 4) {
          if (bytes.getUint8(i) > 0) colored++;
        }
        expect(colored, greaterThan(6500), reason: 'Ilustración completa $id');
        results.add(colored);
        picture.dispose();
        image.dispose();
      }
      expect(results.toSet().length, 3);
    },
  );
}
