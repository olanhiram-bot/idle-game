import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/domain/lantern_run.dart';

LanternRun funded() {
  final run = LanternRun(now: () => Duration.zero, campaign: true);
  return LanternRun.fromJson({
    ...run.toJson(),
    'gold': 100,
  }, now: () => Duration.zero);
}

void main() {
  test('Comprar y mejorar habilidades descuenta oro y limita rango', () {
    final run = funded();
    expect(run.buySkill('golpe'), isTrue);
    expect(run.gold, 94);
    expect(run.skillRank('golpe'), 1);
    expect(run.buySkill('golpe'), isTrue);
    expect(run.gold, 82);
    expect(run.buySkill('golpe'), isTrue);
    expect(run.buySkill('golpe'), isFalse);
    expect(run.buySkill('falsa'), isFalse);
    final restored = LanternRun.fromJson(
      run.toJson(),
      now: () => Duration.zero,
    );
    expect(restored.skillRank('golpe'), 3);
    expect(restored.gold, run.gold);
    run.beginEncounter(0);
    expect(run.buySkill('cura'), isFalse);
  });
  test('Golpe usa maná y cooldown; cura recupera y hielo retrasa enemigo', () {
    var t = Duration.zero;
    final run = LanternRun.fromJson(funded().toJson(), now: () => t);
    for (final id in ['golpe', 'cura', 'hielo']) {
      run.buySkill(id);
    }
    run.beginEncounter(0);
    expect(run.useSkill('golpe'), isTrue);
    expect(run.enemyHealth, 4);
    expect(run.mana, 4);
    expect(run.useSkill('golpe'), isFalse);
    t += const Duration(seconds: 1);
    run.sample();
    expect(run.skillCooldownMs, 0);
    run.heroHealth = 10;
    expect(run.useSkill('cura'), isTrue);
    expect(run.heroHealth, 16);
    t += const Duration(seconds: 1);
    run.sample();
    final before = run.enemyRemainingMs;
    expect(run.useSkill('hielo'), isTrue);
    expect(run.enemyRemainingMs, greaterThan(before));
    expect(run.mana, 0);
    t += const Duration(seconds: 1);
    run.sample();
    expect(run.useSkill('golpe'), isFalse);
    run.setActive(false);
    final cooldown = run.skillCooldownMs;
    t += const Duration(hours: 1);
    run.sample();
    expect(run.skillCooldownMs, cooldown);
    final restored = LanternRun.fromJson(run.toJson(), now: () => t);
    expect(restored.mana, 0);
  });
  test(
    'Sin oro, habilidad bloqueada o cura a vida completa no consumen recursos',
    () {
      final run = LanternRun(now: () => Duration.zero, campaign: true);
      expect(run.buySkill('golpe'), isFalse);
      run.beginEncounter(0);
      expect(run.useSkill('golpe'), isFalse);
      final rich = funded()..buySkill('cura');
      rich.beginEncounter(0);
      expect(rich.useSkill('cura'), isFalse);
      expect(rich.mana, 6);
    },
  );
}
