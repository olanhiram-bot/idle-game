import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/domain/lantern_run.dart';

void main() {
  test(
    'Cada victoria aumenta el siguiente rango sin alterar combate terminado',
    () {
      var t = Duration.zero;
      final run = LanternRun(now: () => t, campaign: true)..beginEncounter(0);
      final original = run.maxHealth;
      while (!run.encounterWon) {
        run.attack();
        t += const Duration(milliseconds: 350);
      }
      expect(run.maxHealth, original);
      expect(run.nextEnemyHealth(0), greaterThan(original));
      expect(run.beginEncounter(0), isTrue);
      expect(run.battleRank, 1);
      expect(run.maxHealth, greaterThan(original));
      final hp = run.maxHealth;
      run.returnToCamp();
      run.beginEncounter(0);
      expect(run.maxHealth, hp);
      final restored = LanternRun.fromJson(run.toJson(), now: () => t);
      expect(restored.battleRank, 1);
      expect(restored.maxHealth, hp);
      expect(restored.enemyHealth, hp);
    },
  );
  test('Cambio de enemigo respeta bloqueos, rango global y combate activo', () {
    final run = LanternRun(now: () => Duration.zero, campaign: true);
    expect(run.selectEnemy(1), isFalse);
    run.sectorWins[0] = 5;
    expect(run.selectEnemy(1), isTrue);
    expect(run.encounterState, 'preparation');
    expect(run.encounter, 1);
    run.beginEncounter(1);
    expect(run.selectEnemy(0), isFalse);
    run.returnToCamp();
    expect(run.selectEnemy(0), isTrue);
  });
}
