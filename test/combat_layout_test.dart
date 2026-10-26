import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/main.dart';
import 'package:idle_game/domain/lantern_run.dart';

void main() {
  testWidgets('short campaign at 200% keeps tactics reachable', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final run = LanternRun(now: () => Duration.zero, campaign: true)
      ..beginEncounter(0);
    await tester.pumpWidget(
      MyApp(run: run, textScaler: const TextScaler.linear(2)),
    );
    await tester.pump();
    for (final text in ['Atacar', 'Proteger', 'Llamarada · 0/4']) {
      await tester.ensureVisible(find.text(text));
      expect(find.text(text).hitTestable(), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('mobile combat prioritizes tactics in a compact dock', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final run = LanternRun(now: () => Duration.zero, campaign: true)
      ..beginEncounter(0);
    await tester.pumpWidget(MyApp(run: run));
    await tester.pump();
    expect(
      tester.getSize(find.byKey(const Key('command-panel'))).height,
      lessThanOrEqualTo(320),
    );
    for (final text in ['Atacar', 'Proteger', 'Llamarada · 0/4']) {
      expect(find.text(text).hitTestable(), findsOneWidget);
    }
    expect(find.byKey(const Key('enemy-intent')).hitTestable(), findsOneWidget);
    expect(find.text('PM 6/6'), findsOneWidget);
    expect(find.text('Carga 0/4'), findsOneWidget);
    expect(
      find.byTooltip('Mantén pulsado para ver los assets usados'),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
