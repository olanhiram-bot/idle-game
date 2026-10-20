import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/domain/lantern_run.dart';

void main() {
  test(
    'Vitalidad cuesta oro, aumenta vida real y se conserva entre héroes',
    () {
      final base = LanternRun(now: () => Duration.zero, campaign: true);
      final run = LanternRun.fromJson({
        ...base.toJson(),
        'gold': 100,
      }, now: () => Duration.zero);
      expect(run.buyVitality(), isTrue);
      expect(run.gold, 96);
      expect(run.vitality, 1);
      expect(run.maxHeroHealth, 25);
      expect(run.heroHealth, 25);
      run.selectHero('ascua');
      expect(run.maxHeroHealth, 21);
      final saved = LanternRun.fromJson(run.toJson(), now: () => Duration.zero);
      expect(saved.maxHeroHealth, 21);
      expect(saved.vitality, 1);
      saved.beginEncounter(0);
      expect(saved.heroHealth, 21);
      expect(saved.buyVitality(), isFalse);
      expect(saved.gold, 96);
    },
  );
  test(
    'Sin saldo o al límite no cobra; guardados antiguos migran sin reinicio',
    () {
      final base = LanternRun(now: () => Duration.zero, campaign: true);
      expect(base.buyVitality(), isFalse);
      final old = base.toJson()..remove('vitality');
      expect(LanternRun.fromJson(old, now: () => Duration.zero).vitality, 0);
      final rich = LanternRun.fromJson({
        ...base.toJson(),
        'gold': 1000,
      }, now: () => Duration.zero);
      for (var i = 0; i < 10; i++) {
        expect(rich.buyVitality(), isTrue);
      }
      final gold = rich.gold;
      expect(rich.buyVitality(), isFalse);
      expect(rich.gold, gold);
      expect(rich.maxHeroHealth, 70);
      expect(
        () => LanternRun.fromJson({
          ...rich.toJson(),
          'vitality': 11,
        }, now: () => Duration.zero),
        throwsFormatException,
      );
    },
  );
}
