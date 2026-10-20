import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/domain/lantern_run.dart';

void main() {
  test('Un catálogo normal no admite iniciar directamente al jefe', () {
    final run = LanternRun(now: () => Duration.zero, campaign: true);
    expect(run.beginEncounter(3), isFalse);
    expect(run.beginEncounter(-1), isFalse);
    expect(run.equip('pabilo'), isFalse);
  });
  test('Muestrear a distinta frecuencia conserva ataques enemigos', () {
    var t = Duration.zero;
    final slow = LanternRun(now: () => t, campaign: true)..beginEncounter(0);
    final fast = LanternRun(now: () => t, campaign: true)..beginEncounter(0);
    for (var i = 1; i <= 100; i++) {
      t = Duration(milliseconds: i * 100);
      fast.sample();
      if (i % 10 == 0) slow.sample();
    }
    expect(slow.heroHealth, fast.heroHealth);
    expect(slow.enemyRemainingMs, fast.enemyRemainingMs);
  });
  test('Subidas de nivel y límite sobreviven round-trip sin duplicar XP', () {
    var t = Duration.zero;
    final run = LanternRun(now: () => t, campaign: true);
    for (var victory = 0; victory < 25; victory++) {
      run.returnToCamp();
      run.beginEncounter(0);
      while (!run.encounterWon) {
        run.attack();
        t += const Duration(milliseconds: 350);
      }
    }
    expect(run.level, 5);
    expect(run.xp, 50);
    final saved = run.toJson();
    final restored = LanternRun.fromJson(saved, now: () => t);
    expect(restored.level, 5);
    expect(restored.xp, 50);
    expect(restored.attack(), isFalse);
    expect(restored.xp, 50);
  });
}
