import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/domain/lantern_run.dart';
import 'package:idle_game/main.dart';

void main() {
  testWidgets('Ajustes accesibles, persistibles y ayuda repetible sin cobrar', (
    tester,
  ) async {
    var t = Duration.zero;
    final run = LanternRun(now: () => t, campaign: true);
    await tester.pumpWidget(MyApp(run: run));
    await tester.pump();
    await tester.tap(find.text('Mecha'));
    await tester.pump();
    await tester.ensureVisible(find.text('Ajustes y respaldo'));
    await tester.tap(find.text('Ajustes y respaldo'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.ensureVisible(find.text('Reducir movimiento'));
    await tester.tap(find.text('Reducir movimiento'));
    await tester.pump();
    expect(run.reducedMotion, isTrue);
    await tester.ensureVisible(
      find.text('Protección accesible · ventana ampliada'),
    );
    await tester.tap(find.text('Protección accesible · ventana ampliada'));
    await tester.pump();
    expect(run.assistance, isTrue);
    final restored = LanternRun.fromJson(run.toJson(), now: () => t);
    expect(restored.assistance, isTrue);
    expect(restored.reducedMotion, isTrue);
    expect(run.gold, 0);
    await tester.ensureVisible(find.text('Volver al juego'));
    await tester.tap(find.text('Volver al juego'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Ajustes y respaldo'), findsOneWidget);
    await tester.tap(find.text('Combate'));
    await tester.pump();
    await tester.ensureVisible(find.text('Comenzar encuentro'));
    await tester.tap(find.text('Comenzar encuentro'));
    await tester.pump();
    expect(run.running, isTrue);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('Mantener Atacar se cancela al cambiar de pestaña y al soltar', (
    tester,
  ) async {
    var t = Duration.zero;
    final run = LanternRun(now: () => t, campaign: true)..beginEncounter(0);
    await tester.pumpWidget(MyApp(run: run));
    await tester.pump();
    final gesture = await tester.startGesture(
      tester.getCenter(find.text('Atacar')),
    );
    t += const Duration(milliseconds: 350);
    await tester.pump(const Duration(milliseconds: 350));
    expect(run.pulses, 1);
    await gesture.cancel();
    t += const Duration(seconds: 1);
    await tester.pump(const Duration(seconds: 1));
    expect(run.pulses, 1);
    await tester.tap(find.text('Mecha'));
    await tester.pump();
    final hp = run.enemyHealth;
    await tester.tapAt(const Offset(400, 200));
    await tester.pump();
    expect(run.enemyHealth, hp);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
