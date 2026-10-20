import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/domain/lantern_run.dart';

void main() {
  test('Todos los héroes sobreviven cinco encuentros iniciales con ritmo tranquilo', () {
    for (final id in ['farol', 'bastion', 'ascua']) {
      var t = Duration.zero;
      final run = LanternRun(now: () => t, campaign: true)..selectHero(id);
      for (var battle = 0; battle < 5; battle++) {
        expect(run.beginEncounter(0), isTrue);
        expect(run.heroHealth, run.maxHeroHealth);
        for (var tick = 0; tick < 180 && run.running; tick++) {
          t += const Duration(milliseconds: 500);
          run.sample();
          if (tick % 2 == 0) run.attack();
          if (run.canFlare) run.flare();
        }
        expect(run.encounterWon, isTrue, reason: '$id pelea $battle');
        expect(
          run.heroHealth,
          greaterThan(run.maxHeroHealth ~/ 2),
          reason: '$id pelea $battle',
        );
      }
    }
  });
  test(
    'Descanso restaura vida fuera de pelea sin dar oro ni subir dificultad',
    () {
      final run = LanternRun(now: () => Duration.zero, campaign: true);
      run.heroHealth = 1;
      run.returnToCamp();
      expect(run.heroHealth, run.maxHeroHealth);
      expect(run.gold, 0);
      expect(run.nextRank, 0);
    },
  );
}
