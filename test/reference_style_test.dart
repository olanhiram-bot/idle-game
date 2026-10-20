import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/main.dart';
import 'package:idle_game/domain/lantern_run.dart';

void main() {
  testWidgets('Estadísticas visuales y academia conservan datos y acciones', (
    tester,
  ) async {
    await tester.pumpWidget(
      MyApp(run: LanternRun(now: () => Duration.zero, campaign: true)),
    );
    await tester.pump();
    await tester.tap(find.text('Mecha'));
    await tester.pump();
    expect(find.byKey(const Key('skill-emblem-golpe')), findsOneWidget);
    await tester.tap(find.text('Elegir personaje'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('VIDA'), findsOneWidget);
    expect(find.text('DAÑO'), findsOneWidget);
    expect(find.text('NIVEL'), findsOneWidget);
    expect(find.byKey(const Key('hero-choice-farol')), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
