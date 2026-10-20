import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/presentation/game_controls.dart' as game;

void main() {
  testWidgets('Controles propios responden y respetan bloqueo', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              game.FilledButton(
                onPressed: () => taps++,
                child: const Text('Atacar'),
              ),
              const game.FilledButton(
                onPressed: null,
                child: Text('Bloqueado'),
              ),
              game.SwitchListTile(
                title: const Text('Sonido'),
                value: false,
                onChanged: (_) => taps++,
              ),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.text('Atacar'));
    await tester.tap(find.text('Bloqueado'));
    await tester.tap(find.text('Sonido'));
    expect(taps, 2);
    expect(find.byType(FilledButton), findsNothing);
    expect(find.byType(Switch), findsNothing);
  });
}
