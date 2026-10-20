import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/domain/lantern_run.dart';
import 'package:idle_game/main.dart';

void main() {
  testWidgets('Identidad ilustrada y equipo conservan acciones en móvil', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final run = LanternRun(now: () => Duration.zero, campaign: true);
    await tester.pumpWidget(MyApp(run: run));
    await tester.pump();
    expect(find.text('GALERÍA DE LOS ECOS'), findsOneWidget);
    expect(find.text('Comenzar encuentro').hitTestable(), findsOneWidget);
    await tester.tap(find.text('Mecha'));
    await tester.pump();
    expect(find.text('El taller del farol'), findsOneWidget);
    expect(find.text('+1 de daño en cada ataque'), findsOneWidget);
    await tester.ensureVisible(find.text('Brasa'));
    await tester.tap(find.text('Brasa'));
    await tester.pump();
    expect(run.equipped, contains('brasa'));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
