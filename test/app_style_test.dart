import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/main.dart';
import 'package:idle_game/domain/lantern_run.dart';

void main() {
  testWidgets('Estilo RPG compartido en combate, ruta y ajustes', (
    tester,
  ) async {
    final run = LanternRun(now: () => Duration.zero, campaign: true);
    await tester.pumpWidget(MyApp(run: run));
    await tester.pump();
    expect(find.byKey(const Key('hud-hero-portrait')), findsOneWidget);
    await tester.tap(find.text('Comenzar encuentro'));
    await tester.pump();
    expect(find.byKey(const Key('attack-command-emblem')), findsOneWidget);
    await tester.tap(find.text('Ruta'));
    await tester.pump();
    expect(find.byKey(const Key('route-emblem-0')), findsOneWidget);
    await tester.ensureVisible(find.text('Ajustes y respaldo'));
    await tester.tap(find.text('Ajustes y respaldo'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byKey(const Key('settings-emblem')), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
