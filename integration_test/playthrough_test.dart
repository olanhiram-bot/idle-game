import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:idle_game/main.dart';
import 'package:idle_game/domain/lantern_run.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Partida jugable completa el primer encuentro con habilidad', (
    tester,
  ) async {
    var time = Duration.zero;
    final run = LanternRun(now: () => time, campaign: true);
    await tester.pumpWidget(MyApp(run: run));
    await tester.pump();
    await tester.tap(find.text('Comenzar encuentro'));
    await tester.pump();
    for (var i = 0; i < 8 && !run.encounterWon; i++) {
      await tester.tap(find.text('Atacar'));
      time += const Duration(milliseconds: 350);
      await tester.pump();
      if (run.canFlare) {
        await tester.tap(find.text('Llamarada · lista'));
        await tester.pump();
      }
    }
    expect(run.encounterWon, isTrue);
    expect(run.gold, 2);
    await tester.tap(find.text('Mecha'));
    await tester.pump();
    expect(find.textContaining('XP 2'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
