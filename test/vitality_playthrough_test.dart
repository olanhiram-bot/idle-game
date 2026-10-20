import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/domain/lantern_run.dart';

void main() {
  test('Ganar dos peleas paga vitalidad y la tercera usa la nueva vida', () {
    var time = Duration.zero;
    final run = LanternRun(now: () => time, campaign: true);
    for (var battle = 0; battle < 2; battle++) {
      run.beginEncounter(0);
      for (var tick = 0; tick < 180 && run.running; tick++) {
        time += const Duration(milliseconds: 500);
        run.sample();
        if (tick % 2 == 0) run.attack();
        if (run.canFlare) run.flare();
      }
      expect(run.encounterWon, isTrue);
    }
    expect(run.gold, 4);
    expect(run.buyVitality(), isTrue);
    expect(run.gold, 0);
    final saved = LanternRun.fromJson(run.toJson(), now: () => time);
    saved.beginEncounter(0);
    expect(saved.heroHealth, 25);
    expect(saved.battleRank, 2);
  });
}
