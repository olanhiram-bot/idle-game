import 'dart:ui';

import 'characters.dart';
import 'kenney_sprites.dart';

abstract final class EnemyArt {
  static void paint(
    Canvas c,
    int kind, {
    double attack = 0,
    double hit = 0,
    bool defeated = false,
  }) {
    final pose = defeated
        ? 3
        : hit > .000001
        ? 2
        : attack > .000001
        ? (attack > .65 ? 5 : 1)
        : 0;
    final sprite = KenneySprites.enemy(kind, pose);
    if (KenneySprites.image(sprite) != null) {
      c.save();
      c.translate(-attack * 20 + hit * 6, 0);
      c.drawOval(
        const Rect.fromLTWH(380, 276, 100, 12),
        Paint()..color = const Color(0x66040F23),
      );
      final size = kind == 3 ? 218.0 : 190.0;
      KenneySprites.paint(
        c,
        sprite,
        Rect.fromLTWH(430 - size / 2, 284 - size, size, size),
      );
      if (kind == 1 && !defeated) {
        c.drawOval(
          const Rect.fromLTWH(369, 142, 122, 142),
          Paint()
            ..color = const Color(0x887BD8D2)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3,
        );
      }
      c.restore();
      return;
    }
    if (kind == 0) {
      Characters.sootling(c, bob: -attack * 8, hit: hit);
      return;
    }
    final p = Paint();
    void shape(Path path, List<Color> colors) {
      final r = path.getBounds();
      c.drawPath(
        path,
        p
          ..style = PaintingStyle.fill
          ..shader = Gradient.linear(r.topLeft, r.bottomRight, colors),
      );
      c.drawPath(
        path,
        p
          ..shader = null
          ..color = const Color(0xFF14243A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeJoin = StrokeJoin.round,
      );
    }

    void oval(double x, double y, double rx, double ry, int color) =>
        c.drawOval(
          Rect.fromCenter(center: Offset(x, y), width: rx * 2, height: ry * 2),
          p
            ..shader = null
            ..style = PaintingStyle.fill
            ..color = Color(color),
        );
    void line(Offset a, Offset b, int color, double width) => c.drawLine(
      a,
      b,
      p
        ..shader = null
        ..color = Color(color)
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round,
    );
    c.save();
    c.translate(-attack * 20 + hit * 6, 0);
    oval(430, 283, kind == 3 ? 64 : 48, 8, 0x66040F23);
    if (kind == 1) {
      // Scarabée de pierre: dos blindé, six pattes, cornes courtes.
      for (var i = 0; i < 3; i++) {
        line(
          Offset(403 + i * 15, 258),
          Offset(380 + i * 18, 278),
          0xFF756F8A,
          8,
        );
        line(
          Offset(439 + i * 12, 257),
          Offset(448 + i * 17, 276),
          0xFF756F8A,
          8,
        );
      }
      shape(
        Path()
          ..moveTo(384, 249)
          ..quadraticBezierTo(383, 188, 433, 184)
          ..quadraticBezierTo(484, 185, 483, 248)
          ..lineTo(468, 268)
          ..lineTo(402, 269)
          ..close(),
        const [Color(0xFFAAB9C0), Color(0xFF55657D)],
      );
      line(const Offset(432, 192), const Offset(432, 257), 0xFF334459, 4);
      for (var i = 0; i < 3; i++) {
        line(
          Offset(397, 212 + i * 14),
          Offset(466, 212 + i * 14),
          0xFFDBD1AB,
          2,
        );
      }
      oval(431, 257, 29, 20, 0xFF33435B);
      oval(418, 254, 6, 8, 0xFFFFD385);
      oval(445, 254, 6, 8, 0xFFFFD385);
    } else if (kind == 2) {
      // Prédateur allongé: museau, queue et pattes de course.
      shape(
        Path()
          ..moveTo(466, 239)
          ..quadraticBezierTo(506, 230, 494, 201)
          ..quadraticBezierTo(520, 231, 480, 257)
          ..close(),
        const [Color(0xFFAD79AB), Color(0xFF51446A)],
      );
      for (final x in [401.0, 449.0]) {
        line(Offset(x, 249), Offset(x - 14, 278), 0xFF544B72, 11);
        line(Offset(x - 16, 279), Offset(x + 1, 279), 0xFFE0B99C, 4);
      }
      shape(
        Path()
          ..moveTo(394, 238)
          ..quadraticBezierTo(413, 201, 465, 224)
          ..lineTo(479, 251)
          ..quadraticBezierTo(438, 269, 402, 256)
          ..close(),
        const [Color(0xFFAB7FA9), Color(0xFF4B436C)],
      );
      shape(
        Path()
          ..moveTo(397, 251)
          ..lineTo(376, 245)
          ..lineTo(390, 221)
          ..lineTo(386, 194)
          ..lineTo(407, 213)
          ..lineTo(423, 198)
          ..lineTo(426, 242)
          ..close(),
        const [Color(0xFFB89AB6), Color(0xFF645476)],
      );
      oval(400, 231, 6, 4, 0xFFFFD676);
      line(const Offset(381, 246), const Offset(397, 250), 0xFF211E38, 2);
    } else {
      // Gardien monumental: corps de pierre, bras flottants et noyau central.
      shape(
        Path()
          ..moveTo(397, 199)
          ..lineTo(462, 198)
          ..lineTo(480, 268)
          ..lineTo(451, 282)
          ..lineTo(407, 280)
          ..lineTo(382, 265)
          ..close(),
        const [Color(0xFF678E9C), Color(0xFF283C58)],
      );
      for (final x in [364.0, 480.0]) {
        shape(
          Path()
            ..moveTo(x, 213)
            ..lineTo(x + 22, 207)
            ..lineTo(x + 27, 248)
            ..lineTo(x + 8, 260)
            ..lineTo(x - 5, 244)
            ..close(),
          const [Color(0xFF88AFB5), Color(0xFF3B5573)],
        );
      }
      shape(
        Path()
          ..moveTo(399, 195)
          ..lineTo(393, 164)
          ..lineTo(410, 177)
          ..lineTo(430, 143)
          ..lineTo(449, 177)
          ..lineTo(470, 162)
          ..lineTo(463, 196)
          ..close(),
        const [Color(0xFFC4D7CD), Color(0xFF62858E)],
      );
      oval(418, 189, 6, 4, 0xFFFFD178);
      oval(447, 189, 6, 4, 0xFFFFD178);
      shape(
        Path()
          ..moveTo(430, 211)
          ..lineTo(448, 234)
          ..lineTo(431, 256)
          ..lineTo(412, 234)
          ..close(),
        const [Color(0xFFFFE1A1), Color(0xFFE39857)],
      );
      line(const Offset(400, 258), const Offset(416, 268), 0xFFB2D3C9, 3);
    }
    c.restore();
  }
}
