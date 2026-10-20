import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/domain/lantern_run.dart';

void main() {
  test('Tres héroes cambian estadísticas solo fuera de combate', () {
    final run = LanternRun(now: () => Duration.zero, campaign: true);
    expect(run.selectHero('bastion'), isTrue);
    expect(run.maxHeroHealth, 28);
    expect(run.beginEncounter(0), isTrue);
    expect(run.heroHealth, 28);
    expect(run.selectHero('ascua'), isFalse);
    run.returnToCamp();
    expect(run.selectHero('ascua'), isTrue);
    expect(run.damage, 2);
    expect(run.maxHeroHealth, 16);
    expect(run.selectHero('desconocido'), isFalse);
    final restored = LanternRun.fromJson(
      run.toJson(),
      now: () => Duration.zero,
    );
    expect(restored.heroId, 'ascua');
    expect(restored.maxHeroHealth, 16);
  });
  test('Guardado anterior migra al guardafaroles sin perder oro', () {
    final old = LanternRun(now: () => Duration.zero, campaign: true).toJson()
      ..['schemaVersion'] = 1
      ..remove('heroId');
    final run = LanternRun.fromJson(old, now: () => Duration.zero);
    expect(run.heroId, 'farol');
    expect(run.toJson()['schemaVersion'], 2);
    expect(
      () => LanternRun.fromJson({
        ...run.toJson(),
        'heroId': 'invalido',
      }, now: () => Duration.zero),
      throwsFormatException,
    );
  });
}
