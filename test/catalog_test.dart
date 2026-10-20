import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/domain/content.dart';
import 'package:idle_game/domain/lantern_run.dart';

void main() {
  test('Catálogo finito tiene IDs únicos y números acotados', () {
    expect(enemies.map((e) => e.id).toSet().length, enemies.length);
    expect(enemies.length, 4);
    for (final e in enemies) {
      expect(e.health, inInclusiveRange(1, 100));
      expect(e.damage, inInclusiveRange(1, 20));
      expect(e.periodMs, inInclusiveRange(1000, 10000));
      expect(e.description, isNotEmpty);
    }
    expect(moduleNames.keys.toSet(), {'brasa', 'cristal', 'guarda', 'pabilo'});
  });
  test('Cambiar módulos durante pelea o menú suspendido está bloqueado', () {
    final run = LanternRun(now: () => Duration.zero, campaign: true);
    expect(run.equip('brasa'), isTrue);
    expect(run.damage, 2);
    run.beginEncounter(0);
    run.setActive(false);
    expect(run.equip('brasa'), isFalse);
    expect(run.damage, 2);
    run.returnToCamp();
    expect(run.equip('brasa'), isTrue);
    expect(run.damage, 1);
  });
}
