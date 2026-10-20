import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/domain/lantern_run.dart';

void main() {
  test(
    'Campaña anuncia daño, protege, persiste cooldown y permite reintentar',
    () {
      var time = Duration.zero;
      final run = LanternRun(now: () => time, campaign: true);
      run.beginEncounter(0);
      for (var i = 0; i < 3; i++) {
        time += const Duration(seconds: 1);
        run.sample();
      }
      expect(run.enemyIntent, isTrue);
      expect(run.protect(), isTrue);
      final saved = run.toJson();
      final restored = LanternRun.fromJson(saved, now: () => time);
      expect(restored.protectionMs, run.protectionMs);
      time += const Duration(milliseconds: 500);
      restored.sample();
      expect(restored.heroHealth, 19);
      restored.setActive(false);
      time += const Duration(hours: 1);
      restored.sample();
      expect(restored.heroHealth, 19);
      restored.setActive(true);
      for (var i = 0; i < 100; i++) {
        time += const Duration(seconds: 1);
        restored.sample();
      }
      expect(restored.defeated, isTrue);
      expect(restored.retry(), isTrue);
      expect(restored.heroHealth, restored.maxHeroHealth);
    },
  );
  test('Módulos, encargos y jefe tienen progreso finito e idempotente', () {
    var time = Duration.zero;
    final run = LanternRun(now: () => time, campaign: true);
    for (var e = 0; e < 3; e++) {
      for (var victory = 0; victory < 5; victory++) {
        expect(run.beginEncounter(e), isTrue);
        while (!run.encounterWon) {
          run.attack();
          if (run.canFlare) run.flare();
          time += const Duration(milliseconds: 350);
        }
      }
    }
    expect(run.litLanterns, 3);
    expect(run.beginEncounter(3), isTrue);
    while (!run.encounterWon) {
      run.attack();
      if (run.canFlare) run.flare();
      time += const Duration(milliseconds: 350);
    }
    expect(run.bossDefeated, isTrue);
    expect(run.level, greaterThan(1));
    run.returnToCamp();
    expect(run.equip('brasa'), isTrue);
    expect(run.equip('cristal'), isTrue);
    expect(run.equipped.length, 2);
    expect(run.claimQuest(0), isTrue);
    expect(run.claimQuest(0), isFalse);
    expect(
      LanternRun.fromJson(run.toJson(), now: () => time).bossDefeated,
      isTrue,
    );
  });
}
