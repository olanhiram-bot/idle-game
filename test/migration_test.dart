import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/domain/lantern_run.dart';

void main() {
  test('Migración a campaña mantiene oro, mecha y faroles anteriores', () {
    final run = LanternRun(now: () => Duration.zero);
    final legacy = {
      ...run.toJson(),
      'victories': 10,
      'gold': 20,
      'upgrades': 2,
    };
    final migrated = LanternRun.fromLegacy(legacy, now: () => Duration.zero);
    expect(migrated.campaign, isTrue);
    expect(migrated.litLanterns, 2);
    expect(migrated.gold, 20);
    expect(migrated.upgrades, 2);
    expect(migrated.encounterState, 'preparation');
  });
}
