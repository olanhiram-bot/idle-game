import 'dart:ui';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:idle_game/presentation/enemy_art.dart';

void main() {
  test('Cuatro enemigos tienen dibujos distintos en reposo y ataque', () async {
    final counts = <int>[];
    for (var i = 0; i < 4; i++) {
      final recorder = PictureRecorder();
      EnemyArt.paint(Canvas(recorder), i, attack: .5, hit: .2);
      final pic = recorder.endRecording();
      final image = await pic.toImage(600, 320);
      final png = await image.toByteData(format: ImageByteFormat.png);
      final scratch = Platform.environment['TMPDIR'];
      if (scratch != null) {
        await File('$scratch/enemy-$i.png')
            .writeAsBytes(png!.buffer.asUint8List());
      }
      final data = (await image.toByteData())!;
      var count = 0;
      for (var j = 3; j < data.lengthInBytes; j += 4) {
        if (data.getUint8(j) > 0) count++;
      }
      expect(count, greaterThan(3000));
      counts.add(count);
      image.dispose();
      pic.dispose();
    }
    expect(counts.toSet().length, 4);
  });
}
