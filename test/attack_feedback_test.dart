import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/domain/lantern_run.dart';
import 'package:idle_game/presentation/lantern_scene.dart';
import 'package:idle_game/presentation/kenney_sprites.dart';

void main() {
  tearDown(KenneySprites.clear);
  test(
    'El golpe final conserva animación y daño real aunque termine pelea',
    () {
      final run = LanternRun(now: () => Duration.zero, campaign: true);
      run.selectHero('ascua');
      run.beginEncounter(0);
      final scene = LanternScene(run);
      run.attack();
      scene.update(.01);
      expect(scene.attackProgress, lessThan(1));
      expect(run.lastDamage, 2);
      expect(run.lastAction, 'attack');
      scene.update(.6);
      expect(scene.attackProgress, 1);
    },
  );
  test(
    'Ataques enemigos registran daño y bloqueo sin recompensas duplicadas',
    () {
      var t = Duration.zero;
      final run = LanternRun(now: () => t, campaign: true)..beginEncounter(0);
      for (var i = 0; i < 3; i++) {
        t += const Duration(seconds: 1);
        run.sample();
      }
      run.protect();
      t += const Duration(milliseconds: 500);
      run.sample();
      expect(run.enemyStrikes, 1);
      expect(run.lastIncomingDamage, 1);
      expect(run.lastBlocked, isTrue);
      expect(run.heroHealth, 19);
      expect(run.gold, 0);
    },
  );
  test('El remate dispara animación incluso después de victoria', () {
    var t = Duration.zero;
    final run = LanternRun(now: () => t, campaign: true)..selectHero('ascua');
    run.beginEncounter(0);
    final scene = LanternScene(run);
    for (var i = 0; i < 4; i++) {
      run.attack();
      t += const Duration(milliseconds: 350);
    }
    expect(run.encounterWon, isTrue);
    scene.update(.01);
    expect(scene.attackProgress, lessThan(1));
    scene.update(.6);
    expect(scene.attackProgress, 1);
    expect(run.gold, 2);
  });
}
