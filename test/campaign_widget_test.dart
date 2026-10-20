import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/main.dart';
import 'package:idle_game/domain/lantern_run.dart';

void main() {
  testWidgets('Campaña real comienza, protege y navega sin daño oculto', (
    tester,
  ) async {
    var time = Duration.zero;
    final run = LanternRun(now: () => time, campaign: true);
    await tester.pumpWidget(MyApp(run: run));
    await tester.pump();
    await tester.tap(find.text('Comenzar encuentro'));
    await tester.pump();
    expect(run.running, isTrue);
    expect(find.text('Atacar').hitTestable(), findsOneWidget);
    await tester.tap(find.text('Atacar'));
    await tester.pump();
    expect(run.enemyHealth, 7);
    await tester.tap(find.text('Ruta'));
    await tester.pump();
    final hp = run.heroHealth;
    time += const Duration(hours: 1);
    await tester.pump(const Duration(seconds: 1));
    expect(run.heroHealth, hp);
    await tester.tap(find.text('Combate'));
    await tester.pump();
    expect(run.running, isTrue);
    await tester.tap(find.text('Proteger'));
    await tester.pump();
    expect(run.protectionMs, greaterThan(0));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets(
    'Campaña accesible a 200% permite encontrar encuentro y ajustes',
    (tester) async {
      tester.view.physicalSize = const Size(320, 740);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final run = LanternRun(now: () => Duration.zero, campaign: true);
      await tester.pumpWidget(
        MyApp(run: run, textScaler: const TextScaler.linear(2)),
      );
      await tester.pump();
      await tester.ensureVisible(find.text('Comenzar encuentro'));
      await tester.tap(find.text('Comenzar encuentro'));
      await tester.pump();
      await tester.ensureVisible(find.text('Atacar'));
      expect(find.text('Atacar').hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
