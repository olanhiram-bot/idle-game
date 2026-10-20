import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/main.dart';
import 'package:idle_game/domain/lantern_run.dart';

void main() {
  testWidgets(
    'Escena a pantalla completa, barras contextuales y tabs inferiores',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(MyApp(run: LanternRun(now: () => Duration.zero)));
      await tester.pump();
      final scene = find.byWidgetPredicate((w) => w is GameWidget);
      expect(tester.getSize(scene), const Size(390, 844));
      expect(find.byKey(const Key('enemy-health')), findsOneWidget);
      expect(find.byKey(const Key('hero-charge')), findsOneWidget);
      expect(
        tester.getRect(find.byKey(const Key('enemy-health'))).bottom,
        lessThan(tester.getRect(find.byKey(const Key('command-panel'))).top),
      );
      expect(tester.getRect(find.text('Combate')).top, greaterThan(740));
      expect(find.text('Atacar').hitTestable(), findsOneWidget);
      await tester.tap(find.text('Mecha'));
      await tester.pump();
      expect(find.text('Reforzar mecha · 6 oro'), findsOneWidget);
      expect(find.text('Atacar'), findsNothing);
      await tester.tap(find.text('Ruta'));
      await tester.pump();
      expect(find.text('Faroles encendidos: 0/3'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'Ataques, habilidad, compra y pausa conservan su estado al cambiar tab',
    (tester) async {
      var elapsed = Duration.zero;
      final run = LanternRun(now: () => elapsed);
      await tester.pumpWidget(MyApp(run: run));
      await tester.pump();
      for (var i = 0; i < 4; i++) {
        await tester.tap(find.text('Atacar'));
        elapsed += const Duration(milliseconds: 350);
        await tester.pump();
      }
      expect(run.gold, 2);
      await tester.tap(find.text('Llamarada · lista'));
      await tester.pump();
      expect(run.enemyHealth, 1);
      expect(run.charge, 0);
      await tester.tap(find.text('Activar automático'));
      await tester.pump();
      for (var i = 0; i < 5; i++) {
        elapsed += const Duration(seconds: 1);
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(run.gold, 6);
      await tester.tap(find.text('Mecha'));
      await tester.pump();
      await tester.tap(find.text('Reforzar mecha · 6 oro'));
      await tester.pump();
      expect(run.damage, 2);
      expect(run.gold, 0);
      await tester.tap(find.byTooltip('Pausar'));
      await tester.pump();
      final pulses = run.pulses;
      elapsed += const Duration(hours: 3);
      await tester.pump(const Duration(seconds: 1));
      expect(run.pulses, pulses);
      await tester.tap(find.text('Combate'));
      await tester.pump();
      expect(find.byTooltip('Reanudar'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('Suspensión respeta la pausa manual y no acumula progreso', (
    tester,
  ) async {
    var elapsed = Duration.zero;
    final run = LanternRun(now: () => elapsed, autoAttack: true);
    await tester.pumpWidget(MyApp(run: run));
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    elapsed += const Duration(hours: 1);
    await tester.pump(const Duration(seconds: 1));
    expect(run.pulses, 0);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    elapsed += const Duration(seconds: 1);
    await tester.pump(const Duration(milliseconds: 100));
    expect(run.pulses, 1);
    await tester.tap(find.byTooltip('Pausar'));
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    elapsed += const Duration(hours: 1);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump(const Duration(seconds: 1));
    expect(run.paused, isTrue);
    expect(run.pulses, 1);
    await tester.pumpWidget(const SizedBox());
  });

  for (final size in [const Size(320, 740), const Size(844, 390)]) {
    testWidgets('Tabs y acciones accesibles a 200% en $size con zona segura', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      tester.view.padding = FakeViewPadding(top: 24, bottom: 34);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPadding);
      await tester.pumpWidget(const MyApp(textScaler: TextScaler.linear(2)));
      await tester.pump();
      expect(find.text('Atacar').hitTestable(), findsOneWidget);
      await tester.tap(find.text('Mecha'));
      await tester.pump();
      await tester.ensureVisible(find.text('Reforzar mecha · 6 oro'));
      expect(find.text('Reforzar mecha · 6 oro').hitTestable(), findsOneWidget);
      expect(
        tester.getRect(find.byKey(const Key('bottom-tabs'))).bottom,
        lessThanOrEqualTo(size.height - 34),
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
