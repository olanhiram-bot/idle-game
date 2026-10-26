import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/domain/lantern_run.dart';
import 'package:idle_game/presentation/character_view.dart';
import 'package:idle_game/main.dart';

void main() {
  testWidgets('confirmation remains reachable with large text and safe areas', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    tester.view.padding = FakeViewPadding(top: 24, bottom: 34);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPadding);
    final run = LanternRun(now: () => Duration.zero, campaign: true);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: CharacterView(run: run),
      ),
    );
    expect(find.text('Jugar con Luz').hitTestable(), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('hero-choice-vigia')));
    await tester.tap(find.byKey(const Key('hero-choice-vigia')));
    await tester.pump();
    expect(find.text('Jugar con Vigía').hitTestable(), findsOneWidget);
    expect(run.heroId, 'farol');
    expect(
      tester.getRect(find.byKey(const Key('hero-confirmation'))).bottom,
      lessThanOrEqualTo(606),
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('four hero choices and confirmation visible on phone', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final run = LanternRun(now: () => Duration.zero, campaign: true);
    await tester.pumpWidget(MaterialApp(home: CharacterView(run: run)));
    for (final id in ['farol', 'bastion', 'ascua', 'vigia']) {
      expect(find.byKey(Key('hero-choice-$id')).hitTestable(), findsOneWidget);
    }
    expect(find.text('Jugar con Luz').hitTestable(), findsOneWidget);
    await tester.tap(find.byKey(const Key('hero-choice-vigia')));
    await tester.pump();
    expect(run.heroId, 'farol');
    expect(find.text('Jugar con Vigía').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
    'management tabs hide combat meters and keep purchases reachable',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final run = LanternRun(now: () => Duration.zero, campaign: true);
      await tester.pumpWidget(MyApp(run: run));
      await tester.pump();
      await tester.tap(find.text('Mecha'));
      await tester.pump();
      expect(find.byKey(const Key('enemy-health')), findsNothing);
      expect(find.text('Elegir personaje').hitTestable(), findsOneWidget);
      expect(find.text('Mejorar vida · 4 oro').hitTestable(), findsOneWidget);
      await tester.tap(find.text('Ruta'));
      await tester.pump();
      expect(find.byKey(const Key('hero-charge')), findsNothing);
      expect(find.text('Zombi errante').hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
