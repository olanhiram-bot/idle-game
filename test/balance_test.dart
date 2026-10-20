import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/domain/lantern_run.dart';

void main() {
  test('Ruta completa con tiempo activo real, mejoras y protección', () {
    var time = Duration.zero;
    final run = LanternRun(now: () => time, campaign: true);
    for (var index = 0; index < 4; index++) {
      final battles = index == 3 ? 1 : 5;
      for (var b = 0; b < battles; b++) {
        run.returnToCamp();
        while (run.canUpgrade) {
          run.buyUpgrade();
        }
        if (run.moduleUnlocked('brasa') && !run.equipped.contains('brasa')) {
          run.equip('brasa');
        }
        if (run.moduleUnlocked('cristal') &&
            !run.equipped.contains('cristal')) {
          run.equip('cristal');
        }
        expect(run.beginEncounter(index), isTrue);
        for (
          var tick = 0;
          tick < 3000 && !run.encounterWon && !run.defeated;
          tick++
        ) {
          time += const Duration(milliseconds: 100);
          run.sample();
          if (run.enemyIntent && run.protectCooldownMs == 0) run.protect();
          run.attack();
          if (run.canFlare && !run.armored) run.flare();
        }
        expect(run.defeated, isFalse, reason: 'Encuentro $index ronda $b');
        expect(run.encounterWon, isTrue);
        if (run.questReady(0)) run.claimQuest(0);
        if (run.questReady(1)) run.claimQuest(1);
      }
    }
    expect(run.bossDefeated, isTrue);
    expect(run.claimQuest(2), isTrue);
    expect(run.claimQuest(2), isFalse);
  });
}
