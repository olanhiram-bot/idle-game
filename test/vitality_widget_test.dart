import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/main.dart';
import 'package:idle_game/domain/lantern_run.dart';

void main() {
  testWidgets('Comprar vida muestra antes/después y combate usa máximo nuevo', (
    tester,
  ) async {
    final base = LanternRun(now: () => Duration.zero, campaign: true);
    final run = LanternRun.fromJson({
      ...base.toJson(),
      'gold': 8,
    }, now: () => Duration.zero);
    await tester.pumpWidget(MyApp(run: run));
    await tester.pump();
    await tester.tap(find.text('Mecha'));
    await tester.pump();
    await tester.ensureVisible(find.text('Mejorar vida · 4 oro'));
    await tester.tap(find.text('Mejorar vida · 4 oro'));
    await tester.pump();
    expect(find.text('Vida máxima 25 → 30'), findsOneWidget);
    expect(run.gold, 4);
    await tester.tap(find.text('Combate'));
    await tester.pump();
    await tester.tap(find.text('Comenzar encuentro'));
    await tester.pump();
    expect(run.heroHealth, 25);
    expect(find.textContaining('Vida 25/25'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
