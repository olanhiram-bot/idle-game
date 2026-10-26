import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/domain/lantern_run.dart';
import 'package:idle_game/presentation/hero_art.dart';
import 'package:idle_game/presentation/kenney_asset_gallery.dart';
import 'package:idle_game/presentation/kenney_sprites.dart';
import 'package:idle_game/presentation/lantern_scene.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('closing gallery preserves combat sprites', (tester) async {
    final scene = LanternScene(LanternRun(now: () => Duration.zero));
    await tester.runAsync(scene.onLoad);
    expect(KenneySprites.imagesLoaded, 36);
    final gallery = KenneyAssetGallery();
    await tester.runAsync(gallery.onLoad);
    gallery.onRemove();
    expect(KenneySprites.imagesLoaded, 36);
    scene.onRemove();
    expect(KenneySprites.imagesLoaded, 36);
    KenneySprites.clear();
  });

  testWidgets('all poses paint actual bundled pixels, idle stays idle', (
    tester,
  ) async {
    final scene = LanternScene(LanternRun(now: () => Duration.zero));
    await tester.runAsync(scene.onLoad);
    await tester.runAsync(() async {
      Future<List<int>> render(double action, double hurt) async {
        final r = PictureRecorder();
        HeroArt.paint(Canvas(r), 'farol', action, hurt: hurt);
        final p = r.endRecording();
        final image = await p.toImage(320, 320);
        final bytes = (await image.toByteData())!.buffer.asUint8List().toList();
        image.dispose();
        p.dispose();
        return bytes;
      }

      final idle = await render(0, 0);
      final resting = await render(
        1.2246467991473532e-16,
        1.2246467991473532e-16,
      );
      expect(resting, idle, reason: 'sin(pi) is not exactly zero');
      expect(await render(.8, 0), isNot(idle));
      expect(idle.where((v) => v != 0).length, greaterThan(5000));
    });
    scene.onRemove();
  });

  testWidgets('bundled hero can be decoded without filesystem fallback', (
    tester,
  ) async {
    final data = await rootBundle.load(
      'assets/third_party/kenney/toon-characters/selected/'
      'Male adventurer/PNG/Poses HD/character_maleAdventurer_idle.png',
    );
    expect(data.lengthInBytes, greaterThan(100));
  });
}
