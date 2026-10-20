import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/presentation/hero_art.dart';

void main() {
  test(
    'Tres ilustraciones completas y poses distintas sin errores de pintura',
    () async {
      final results = <int>[];
      for (final id in ['farol', 'bastion', 'ascua']) {
        final recorder = PictureRecorder();
        HeroArt.paint(Canvas(recorder), id, 0);
        final picture = recorder.endRecording();
        final image = await picture.toImage(300, 320);
        final bytes = (await image.toByteData())!;
        var colored = 0;
        for (var i = 3; i < bytes.lengthInBytes; i += 4) {
          if (bytes.getUint8(i) > 0) colored++;
        }
        expect(colored, greaterThan(6500), reason: 'Ilustración completa $id');
        results.add(colored);
        picture.dispose();
        image.dispose();
      }
      expect(results.toSet().length, 3);
    },
  );
}
