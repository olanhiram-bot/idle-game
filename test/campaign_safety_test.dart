import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/domain/lantern_run.dart';

void main() {
  test(
    'Protección se consume en un golpe y el ataque no elimina tiempo residual',
    () {
      var t = Duration.zero;
      final run = LanternRun(now: () => t, campaign: true);
      run.beginEncounter(0);
      t += const Duration(seconds: 3);
      run.sample();
      t += const Duration(seconds: 1);
      run.sample();
      t += const Duration(seconds: 1);
      run.sample();
      expect(run.enemyIntent, isTrue);
      run.protect();
      t += const Duration(milliseconds: 600);
      run.sample();
      expect(run.protectionMs, 0);
    },
  );
  test('Estado restaurado no acepta vida cero en pelea activa ni módulos bloqueados', () {
    final run = LanternRun(now: () => Duration.zero, campaign: true);
    run.beginEncounter(0);
    expect(
      () => LanternRun.fromJson({
        ...run.toJson(),
        'heroHealth': 0,
      }, now: () => Duration.zero),
      throwsFormatException,
    );
    expect(
      () => LanternRun.fromJson({
        ...run.toJson(),
        'equipped': ['pabilo'],
      }, now: () => Duration.zero),
      throwsFormatException,
    );
  });
}
