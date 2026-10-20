import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/main.dart';
import 'package:idle_game/domain/lantern_run.dart';

void main() {
  testWidgets(
    'Galería independiente previsualiza sin cambiar hasta confirmar',
    (tester) async {
      final run = LanternRun(now: () => Duration.zero, campaign: true);
      await tester.pumpWidget(MyApp(run: run));
      await tester.pump();
      await tester.tap(find.text('Mecha'));
      await tester.pump();
      await tester.tap(find.text('Elegir personaje'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('Elige tu guardián'), findsOneWidget);
      await tester.ensureVisible(find.text('Ascua'));
      await tester.tap(find.text('Ascua'));
      await tester.pump();
      expect(run.heroId, 'farol');
      await tester.ensureVisible(find.text('Jugar con Ascua'));
      await tester.tap(find.text('Jugar con Ascua'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(run.heroId, 'ascua');
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
