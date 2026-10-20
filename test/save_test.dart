import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/domain/lantern_run.dart';

void main() {
  test('Snapshot validado conserva progreso y pausa sin tiempo offline', () {
    var time = Duration.zero;
    final run = LanternRun(now: () => time);
    for (var i = 0; i < 4; i++) {
      run.attack();
      time += const Duration(milliseconds: 350);
    }
    run.togglePause();
    final snapshot = run.toJson();
    time += const Duration(hours: 30);
    final restored = LanternRun.fromJson(snapshot, now: () => time);
    expect(restored.gold, 2);
    expect(restored.charge, 4);
    expect(restored.paused, isTrue);
    expect(restored.toJson(), snapshot);
    expect(restored.sample(), isFalse);
  });
  test('Rechaza datos corruptos o futuros, no los normaliza en silencio', () {
    final run = LanternRun(now: () => Duration.zero);
    expect(
      () => LanternRun.fromJson({
        ...run.toJson(),
        'gold': -1,
      }, now: () => Duration.zero),
      throwsFormatException,
    );
    expect(
      () => LanternRun.fromJson({
        ...run.toJson(),
        'schemaVersion': 999,
      }, now: () => Duration.zero),
      throwsFormatException,
    );
    expect(
      () => LanternRun.fromJson({}, now: () => Duration.zero),
      throwsFormatException,
    );
  });
}
