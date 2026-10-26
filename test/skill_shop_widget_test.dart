import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/domain/lantern_run.dart';
import 'package:idle_game/main.dart';

void main() {
  testWidgets('Comprar habilidad con oro y usarla en pelea desde la interfaz', (
    tester,
  ) async {
    final base = LanternRun(now: () => Duration.zero, campaign: true);
    final run = LanternRun.fromJson({
      ...base.toJson(),
      'gold': 20,
    }, now: () => Duration.zero);
    await tester.pumpWidget(MyApp(run: run));
    await tester.pump();
    await tester.tap(find.text('Mecha'));
    await tester.pump();
    await tester.ensureVisible(find.text('Aprender Golpe poderoso · 6 oro'));
    await tester.tap(find.text('Aprender Golpe poderoso · 6 oro'));
    await tester.pump();
    expect(run.gold, 14);
    await tester.tap(find.text('Ruta'));
    await tester.pump();
    await tester.ensureVisible(find.text('Zombi errante'));
    await tester.tap(find.text('Zombi errante'));
    await tester.pump();
    expect(run.encounterState, 'preparation');
    await tester.tap(find.text('Combate'));
    await tester.pump();
    await tester.tap(find.text('Comenzar encuentro'));
    await tester.pump();
    await tester.ensureVisible(find.text('Golpe poderoso · 2 PM'));
    await tester.tap(find.text('Golpe poderoso · 2 PM'));
    await tester.pump();
    expect(run.enemyHealth, 4);
    expect(run.mana, 4);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
