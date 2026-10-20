import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/presentation/hero_art.dart';

void main() {
  test(
    'Reposo defensa impacto derrota y ataque producen poses diferentes',
    () async {
      final hashes = <int>{};
      for (final state in ['idle', 'guard', 'hurt', 'defeat', 'attack']) {
        final r = PictureRecorder();
        HeroArt.paint(
          Canvas(r),
          'bastion',
          state == 'attack' ? .8 : 0,
          defending: state == 'guard',
          hurt: state == 'hurt' ? .8 : 0,
          defeated: state == 'defeat',
        );
        final picture = r.endRecording();
        final image = await picture.toImage(300, 320);
        final bytes = (await image.toByteData())!;
        var hash = 0;
        for (var i = 0; i < bytes.lengthInBytes; i += 4) {
          hash = (hash * 31 + bytes.getUint32(i)) & 0x7fffffff;
        }
        hashes.add(hash);
        image.dispose();
        picture.dispose();
      }
      expect(hashes.length, 5);
    },
  );
}
