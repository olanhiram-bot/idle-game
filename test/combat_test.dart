import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/domain/lantern_run.dart';

void main() {
  test('Pausa y segundo plano descartan tiempo ausente y fracciones', () {
    var elapsed = Duration.zero;
    final run = LanternRun(now: () => elapsed, autoAttack: true);
    elapsed = const Duration(milliseconds: 900);
    run.sample();
    run.togglePause();
    elapsed = const Duration(hours: 3);
    run.sample();
    expect(run.pulses, 0);
    run.setActive(false);
    run.togglePause();
    elapsed += const Duration(hours: 2);
    run.sample();
    expect(run.pulses, 0);
    run.setActive(true);
    elapsed += const Duration(milliseconds: 100);
    run.sample();
    expect(run.pulses, 0);
    elapsed += const Duration(milliseconds: 900);
    run.sample();
    expect(run.pulses, 1);
    run.togglePause();
    run.setActive(false);
    run.setActive(true);
    expect(run.paused, isTrue);
  });

  test('Limita retrasos y descarta saltos de reloj hacia atrás', () {
    var elapsed = Duration.zero;
    final run = LanternRun(now: () => elapsed, autoAttack: true);
    elapsed = const Duration(hours: 20);
    run.sample();
    expect(run.pulses, 1);
    run.sample();
    expect(run.pulses, 1);
    elapsed = Duration.zero;
    run.sample();
    elapsed = const Duration(seconds: 1);
    run.sample();
    expect(run.pulses, 2);
  });

  test('La frecuencia de muestreo no altera el combate activo', () {
    var elapsed = Duration.zero;
    final slow = LanternRun(now: () => elapsed, autoAttack: true);
    final fast = LanternRun(now: () => elapsed, autoAttack: true);
    for (var i = 1; i <= 400; i++) {
      elapsed = Duration(milliseconds: i * 10);
      fast.sample();
      if (i % 100 == 0) slow.sample();
    }
    expect(fast.gold, slow.gold);
    expect(fast.enemyHealth, slow.enemyHealth);
    expect(fast.pulses, slow.pulses);
  });

  test('Tres faroles se restauran y el cierre no se repite', () {
    var elapsed = Duration.zero;
    final run = LanternRun(now: () => elapsed, autoAttack: true);
    for (var victory = 1; victory <= 17; victory++) {
      final pulses = run.maxHealth;
      for (var i = 0; i < pulses; i++) {
        elapsed += const Duration(seconds: 1);
        run.sample();
      }
      expect(run.litLanterns, (victory ~/ 5).clamp(0, 3));
      expect(run.stage, (victory ~/ 5).clamp(0, 2));
    }
    expect(run.completed, isTrue);
    expect(run.victories, 17);
    expect(run.stageVictories, 5);
    expect(run.gold, 34);
    expect(run.completionCount, 1);
  });

  test('La mecha exige saldo, aumenta daño y tiene cinco mejoras', () {
    var elapsed = Duration.zero;
    final run = LanternRun(now: () => elapsed, autoAttack: true);
    expect(run.buyUpgrade(), isFalse);
    expect(run.upgradeCost, 6);
    void collect(int target) {
      while (run.gold < target) {
        elapsed += const Duration(seconds: 1);
        run.sample();
      }
    }

    collect(6);
    expect(run.buyUpgrade(), isTrue);
    expect(run.gold, 0);
    expect(run.damage, 2);
    expect(run.upgradeCost, 10);
    for (var purchase = 1; purchase < 5; purchase++) {
      collect(run.upgradeCost);
      expect(run.buyUpgrade(), isTrue);
    }
    expect(run.damage, 6);
    expect(run.upgrades, 5);
    collect(30);
    final before = run.gold;
    expect(run.buyUpgrade(), isFalse);
    expect(run.gold, before);
  });

  test('El pulso usa tiempo transcurrido y paga una sola vez por victoria', () {
    var elapsed = Duration.zero;
    final run = LanternRun(now: () => elapsed, autoAttack: true);
    expect(run.enemyHealth, 4);
    expect(run.gold, 0);
    elapsed = const Duration(milliseconds: 999);
    run.sample();
    expect(run.enemyHealth, 4);
    elapsed = const Duration(seconds: 1);
    run.sample();
    expect(run.enemyHealth, 3);
    run.sample();
    expect(run.enemyHealth, 3);
    for (var second = 2; second <= 4; second++) {
      elapsed = Duration(seconds: second);
      run.sample();
    }
    expect(run.enemyHealth, 4);
    expect(run.gold, 2);
    expect(run.victories, 1);
    run.sample();
    expect(run.gold, 2);
  });
}
