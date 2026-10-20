import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/domain/lantern_run.dart';

void main() {
  test('Empieza manual; tocar ataca y no permite ráfagas sin límite', () {
    var elapsed = Duration.zero;
    final run = LanternRun(now: () => elapsed);
    elapsed = const Duration(seconds: 1);
    run.sample();
    expect(run.pulses, 0);
    expect(run.autoAttack, isFalse);
    expect(run.attack(), isTrue);
    expect(run.enemyHealth, 3);
    expect(run.attack(), isFalse);
    elapsed += const Duration(milliseconds: 350);
    expect(run.attack(), isTrue);
    expect(run.enemyHealth, 2);
    run.togglePause();
    elapsed += const Duration(seconds: 1);
    expect(run.attack(), isFalse);
    run.togglePause();
    run.setActive(false);
    expect(run.attack(), isFalse);
  });

  test(
    'Cuatro ataques manuales cargan una llamarada que se consume una vez',
    () {
      var elapsed = Duration.zero;
      final run = LanternRun(now: () => elapsed);
      expect(run.flare(), isFalse);
      for (var i = 0; i < 4; i++) {
        expect(run.attack(), isTrue);
        elapsed += const Duration(milliseconds: 350);
      }
      expect(run.charge, 4);
      expect(run.gold, 2);
      expect(run.flare(), isTrue);
      expect(run.enemyHealth, 1);
      expect(run.charge, 0);
      expect(run.flare(), isFalse);
      expect(run.gold, 2);
    },
  );

  test('Automático optativo no carga habilidad y cambiar modo reinicia el intervalo', () {
    var elapsed = Duration.zero;
    final run = LanternRun(now: () => elapsed);
    run.toggleAutoAttack();
    for (var i = 0; i < 4; i++) {
      elapsed += const Duration(seconds: 1);
      run.sample();
    }
    expect(run.gold, 2);
    expect(run.charge, 0);
    run.toggleAutoAttack();
    elapsed += const Duration(seconds: 1);
    run.sample();
    expect(run.pulses, 4);
    run.toggleAutoAttack();
    run.sample();
    expect(run.pulses, 4);
  });
}
