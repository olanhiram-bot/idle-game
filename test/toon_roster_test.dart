import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/domain/content.dart';
import 'package:idle_game/domain/lantern_run.dart';
import 'package:idle_game/presentation/kenney_sprites.dart';
import 'package:idle_game/presentation/hero_art.dart';
import 'package:idle_game/presentation/enemy_art.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('all six actors decode and render distinct combat poses', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await KenneySprites.load();
      expect(KenneySprites.imagesLoaded, 36);
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      canvas.drawColor(const Color(0xFF18343D), BlendMode.src);
      for (var i = 0; i < 6; i++) {
        for (var pose = 0; pose < 3; pose++) {
          canvas.save();
          canvas.translate(i * 200.0 - (i < 4 ? 60 : 330), pose * 230.0 - 60);
          if (i < 4) {
            HeroArt.paint(
              canvas,
              heroes[i].id,
              pose == 1 ? .9 : 0,
              defeated: pose == 2,
            );
          } else {
            EnemyArt.paint(
              canvas,
              i - 4,
              attack: pose == 1 ? .9 : 0,
              defeated: pose == 2,
            );
          }
          canvas.restore();
        }
      }
      final picture = recorder.endRecording();
      final image = await picture.toImage(1200, 690);
      final bytes = (await image.toByteData(format: ImageByteFormat.png))!;
      final scratch = Platform.environment['TMPDIR'];
      if (scratch != null) {
        await File('$scratch/toon-production.png')
            .writeAsBytes(bytes.buffer.asUint8List());
      }
      image.dispose();
      picture.dispose();
    });
  });
  test('four playable humans cover the Toon roster and restore saves', () {
    expect(heroes.length, 4);
    final sprites = <String>{};
    for (final hero in heroes) {
      final run = LanternRun(now: () => Duration.zero, campaign: true);
      expect(run.selectHero(hero.id), isTrue);
      expect(KenneySprites.hero(hero.id, 0), isNotNull);
      sprites.add(KenneySprites.hero(hero.id, 0)!);
      final restored = LanternRun.fromJson(
        run.toJson(),
        now: () => Duration.zero,
      );
      expect(restored.heroId, hero.id);
      expect(restored.maxHeroHealth, run.maxHeroHealth);
    }
    expect(sprites.length, 4);
    sprites.add(KenneySprites.enemy(0, 0));
    sprites.add(KenneySprites.enemy(1, 0));
    expect(sprites.length, 6);
    expect(KenneySprites.enemy(0, 0), contains('zombie'));
    expect(KenneySprites.enemy(1, 0), contains('robot'));
  });
  for (final hero in heroes) {
    test('${hero.name} survives the opening without upgrades', () {
      var time = Duration.zero;
      final run = LanternRun(now: () => time, campaign: true);
      run.selectHero(hero.id);
      run.beginEncounter(0);
      for (var i = 0; i < 20 && !run.encounterWon && !run.defeated; i++) {
        time += const Duration(seconds: 1);
        run.sample();
        run.attack();
      }
      expect(run.encounterWon, isTrue);
      expect(run.defeated, isFalse);
    });
  }
}
