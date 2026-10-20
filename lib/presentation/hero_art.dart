import 'dart:ui';

/// Ilustración original compartida por retrato y combate. Pies en y=284.
abstract final class HeroArt {
  static void paint(
    Canvas canvas,
    String id,
    double action, {
    bool defending = false,
    double hurt = 0,
    bool defeated = false,
  }) {
    final mage = id == 'ascua';
    final knight = id == 'bastion';
    final a = action.clamp(0.0, 1.0);
    final art = _Ink(canvas);
    art.oval(160, 284, 51, 8, 0x66061020);
    canvas.save();
    canvas.translate(160, 282);
    if (defeated) canvas.rotate(-.65);
    if (defending) canvas.scale(.94, .91);
    canvas.rotate(-hurt.clamp(0, 1) * .16);
    canvas.translate(-160, -282);
    canvas.translate(a * 16, -a * 3);
    final base = mage
        ? 0xFF794E91
        : knight
        ? 0xFF456781
        : 0xFF287D80;
    final light = mage
        ? 0xFFC68FC0
        : knight
        ? 0xFFB9D7DF
        : 0xFF90D7BB;
    // Capa asimétrica, forro y pliegues amplios legibles en móvil.
    art.shape(
      Path()
        ..moveTo(132, 203)
        ..cubicTo(117, 220, 119, 251, 103, 269)
        ..quadraticBezierTo(132, 283, 155, 269)
        ..quadraticBezierTo(178, 281, 194, 268)
        ..lineTo(181, 208)
        ..close(),
      [Color(base), const Color(0xFF182A45)],
    );
    art.line(const Offset(128, 224), const Offset(116, 267), light, 2);
    art.line(const Offset(178, 226), const Offset(185, 265), light, 2);
    // Botas de cuero con puntera y suela.
    for (final x in [137.0, 167.0]) {
      art.shape(
        Path()
          ..moveTo(x - 4, 247)
          ..lineTo(x + 12, 247)
          ..lineTo(x + 14, 272)
          ..quadraticBezierTo(x + 25, 276, x + 21, 283)
          ..lineTo(x - 7, 283)
          ..close(),
        const [Color(0xFF765D59), Color(0xFF302D40)],
      );
      art.line(Offset(x - 3, 264), Offset(x + 12, 264), 0xFFD6AD75, 3);
      art.line(Offset(x - 5, 281), Offset(x + 20, 281), 0xFF172133, 3);
    }
    art.shape(
      Path()
        ..moveTo(133, 209)
        ..quadraticBezierTo(155, 197, 180, 210)
        ..lineTo(186, 257)
        ..quadraticBezierTo(158, 270, 130, 256)
        ..close(),
      [Color(light), Color(base), const Color(0xFF263854)],
    );
    // Ceinture, boucle et broche distinctives.
    art.line(const Offset(133, 247), const Offset(182, 247), 0xFF5E4143, 9);
    art.round(const Rect.fromLTWH(152, 242, 13, 12), 3, 0xFFF2C778);
    art.round(const Rect.fromLTWH(156, 245, 5, 6), 1, 0xFF71563F);
    if (knight) {
      art.shape(
        Path()
          ..moveTo(139, 210)
          ..lineTo(174, 210)
          ..lineTo(179, 237)
          ..lineTo(158, 246)
          ..lineTo(136, 236)
          ..close(),
        const [Color(0xFFE5EEE3), Color(0xFF6E9AAD)],
      );
      art.line(const Offset(145, 216), const Offset(168, 216), 0xFFFFFFFF, 2);
      art.diamond(158, 228, 8, 0xFFE9B96B);
    } else {
      art.line(const Offset(137, 216), const Offset(178, 251), 0xFF513D43, 6);
      art.line(const Offset(137, 215), const Offset(178, 250), 0xFFCB9A6C, 3);
      art.round(const Rect.fromLTWH(166, 243, 22, 20), 5, 0xFF92614B);
      art.round(const Rect.fromLTWH(173, 248, 6, 7), 2, 0xFFF1C981);
    }
    // Bras et mains en volume, arme déportée pour silhouette ouverte.
    art.line(
      const Offset(175, 217),
      Offset(199 + a * 10, 224 - a * 8),
      base,
      17,
    );
    art.oval(202 + a * 10, 221 - a * 8, 7, 7, 0xFFF3CBA0);
    art.oval(198 + a * 10, 217 - a * 8, 3, 4, 0xFFFFDDB4);
    for (var finger = 0; finger < 3; finger++) {
      art.line(
        Offset(202 + a * 10, 218 + finger * 3 - a * 8),
        Offset(206 + a * 10, 219 + finger * 3 - a * 8),
        0xFFC88D71,
        1,
      );
    }
    // Cou, visage, oreilles et cheveux : tête plus expressive, non géométrique.
    art.oval(156, 182, 30, 33, 0xFF16273A);
    art.oval(130, 190, 6, 9, 0xFFD99B82);
    art.oval(183, 190, 6, 9, 0xFFD99B82);
    art.shape(
      Path()
        ..moveTo(132, 168)
        ..quadraticBezierTo(157, 149, 181, 170)
        ..lineTo(183, 192)
        ..quadraticBezierTo(181, 214, 158, 217)
        ..quadraticBezierTo(134, 212, 132, 193)
        ..close(),
      const [Color(0xFFFFDFB4), Color(0xFFE2A17F)],
    );
    art.shape(
      Path()
        ..moveTo(131, 180)
        ..quadraticBezierTo(125, 152, 151, 150)
        ..quadraticBezierTo(177, 146, 184, 173)
        ..lineTo(176, 181)
        ..lineTo(169, 169)
        ..lineTo(161, 177)
        ..lineTo(150, 167)
        ..lineTo(138, 181)
        ..close(),
      [Color(mage ? 0xFFAF605B : 0xFF775143), const Color(0xFF453747)],
    );
    for (final x in [145.0, 169.0]) {
      art.oval(x, 191, 6, 8, 0xFFFFF1DA);
      art.oval(x + 1, 192, 3.7, 6, mage ? 0xFF6F407C : 0xFF28596A);
      art.oval(x + 2, 190, 1.5, 2, 0xFFFFFFFF);
      art.line(Offset(x - 4, 180), Offset(x + 4, 179), 0xFF5D3C36, 2.5);
    }
    art.oval(138, 202, 5, 2.5, 0x66C96D70);
    art.oval(177, 202, 5, 2.5, 0x66C96D70);
    art.line(const Offset(157, 196), const Offset(160, 199), 0xFFB87963, 1.5);
    art.curve(
      const Offset(151, 205),
      Offset(
        159,
        knight
            ? 203
            : mage
            ? 208
            : 211,
      ),
      Offset(168, knight ? 205 : 204),
      0xFF945859,
      2,
    );
    if (mage) {
      art.shape(
        Path()
          ..moveTo(120, 169)
          ..quadraticBezierTo(136, 145, 151, 127)
          ..quadraticBezierTo(158, 143, 176, 145)
          ..lineTo(188, 171)
          ..quadraticBezierTo(201, 177, 190, 181)
          ..quadraticBezierTo(155, 189, 117, 177)
          ..close(),
        const [Color(0xFFD68C9C), Color(0xFF744F8E), Color(0xFF453958)],
      );
      art.curve(
        const Offset(128, 172),
        const Offset(158, 182),
        const Offset(183, 173),
        0xFFFFD78F,
        5,
      );
      art.diamond(158, 173, 7, 0xFF8AF2E0);
      art.glow(Offset(221 + a * 8, 196 - a * 9), 35, 0x66FFAE57);
      art.shape(
        Path()
          ..moveTo(211, 209)
          ..quadraticBezierTo(200, 197, 215, 183)
          ..quadraticBezierTo(213, 196, 225, 185)
          ..quadraticBezierTo(241, 205, 224, 212)
          ..close(),
        const [Color(0xFFFFE5A5), Color(0xFFFF8D58)],
      );
      art.oval(220, 201, 5, 8, 0xFFFFF6C5);
    } else if (knight) {
      art.shape(
        Path()
          ..moveTo(124, 178)
          ..quadraticBezierTo(123, 142, 153, 140)
          ..quadraticBezierTo(186, 139, 191, 176)
          ..lineTo(180, 184)
          ..lineTo(175, 166)
          ..lineTo(144, 163)
          ..lineTo(134, 181)
          ..close(),
        const [Color(0xFFE4F1E7), Color(0xFF83A9BC), Color(0xFF42617F)],
      );
      art.line(const Offset(152, 143), const Offset(157, 162), 0xFFFFDA8B, 5);
      art.shape(
        Path()
          ..moveTo(149, 144)
          ..quadraticBezierTo(142, 126, 162, 125)
          ..lineTo(175, 136)
          ..lineTo(157, 137)
          ..close(),
        const [Color(0xFFD5A078), Color(0xFFAB565F)],
      );
      art.shape(
        Path()
          ..moveTo(205, 227)
          ..lineTo(218 + a * 16, 161 + a * 22)
          ..lineTo(226 + a * 16, 145 + a * 22)
          ..lineTo(233 + a * 16, 163 + a * 22)
          ..lineTo(215, 229)
          ..close(),
        const [Color(0xFFF3FAE9), Color(0xFF88BED1)],
      );
      art.line(const Offset(200, 219), const Offset(224, 226), 0xFFFFD080, 5);
      art.shape(
        Path()
          ..moveTo(112, 218)
          ..lineTo(142, 210)
          ..lineTo(151, 237)
          ..quadraticBezierTo(145, 253, 130, 261)
          ..quadraticBezierTo(110, 249, 108, 234)
          ..close(),
        const [Color(0xFF91CED4), Color(0xFF3C6788)],
      );
      art.diamond(130, 234, 11, 0xFFFFD180);
    } else {
      art.shape(
        Path()
          ..moveTo(125, 181)
          ..quadraticBezierTo(119, 157, 148, 137)
          ..quadraticBezierTo(154, 152, 176, 154)
          ..quadraticBezierTo(189, 165, 189, 183)
          ..lineTo(177, 174)
          ..quadraticBezierTo(151, 156, 133, 187)
          ..close(),
        const [Color(0xFF9DE0BF), Color(0xFF3D9F98), Color(0xFF1F6574)],
      );
      art.curve(
        const Offset(129, 168),
        const Offset(137, 152),
        const Offset(148, 146),
        0xFFBAE8C9,
        2,
      );
      art.line(const Offset(201, 279), const Offset(206, 168), 0xFF493B3D, 7);
      art.line(const Offset(202, 274), const Offset(207, 168), 0xFFCEA270, 3);
      art.curve(
        const Offset(206, 171),
        const Offset(226, 153),
        const Offset(237, 180),
        0xFFE8BD75,
        4,
      );
      art.glow(const Offset(237, 210), 38, 0x77FFCD79);
      art.round(const Rect.fromLTWH(224, 193, 26, 32), 5, 0xFFB67C43);
      art.round(const Rect.fromLTWH(228, 197, 18, 23), 3, 0xFFFFD67D);
      art.oval(237, 208, 4, 8, 0xFFFFF5C3);
      art.line(const Offset(237, 181), const Offset(237, 191), 0xFFE5BD78, 2);
    }
    art.curve(
      const Offset(134, 213),
      const Offset(159, 225),
      const Offset(180, 213),
      0xFFEFC27A,
      9,
    );
    art.line(const Offset(139, 221), const Offset(133, 238), 0xFFC78D56, 7);
    canvas.restore();
  }
}

class _Ink {
  _Ink(this.c);
  final Canvas c;
  void shape(Path path, List<Color> colors) {
    final r = path.getBounds();
    c.drawPath(
      path,
      Paint()
        ..shader = Gradient.linear(
          r.topLeft,
          r.bottomRight,
          colors,
          List.generate(colors.length, (i) => i / (colors.length - 1)),
        ),
    );
    c.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF16273A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void oval(double x, double y, double rx, double ry, int color) => c.drawOval(
    Rect.fromCenter(center: Offset(x, y), width: rx * 2, height: ry * 2),
    Paint()..color = Color(color),
  );
  void line(Offset a, Offset b, int color, double width) => c.drawLine(
    a,
    b,
    Paint()
      ..color = Color(color)
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round,
  );
  void curve(Offset a, Offset b, Offset d, int color, double width) =>
      c.drawPath(
        Path()
          ..moveTo(a.dx, a.dy)
          ..quadraticBezierTo(b.dx, b.dy, d.dx, d.dy),
        Paint()
          ..color = Color(color)
          ..style = PaintingStyle.stroke
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round,
      );
  void round(Rect r, double radius, int color) => c.drawRRect(
    RRect.fromRectAndRadius(r, Radius.circular(radius)),
    Paint()..color = Color(color),
  );
  void diamond(double x, double y, double r, int color) => c.drawPath(
    Path()
      ..moveTo(x, y - r)
      ..lineTo(x + r * .7, y)
      ..lineTo(x, y + r)
      ..lineTo(x - r * .7, y)
      ..close(),
    Paint()..color = Color(color),
  );
  void glow(Offset p, double r, int color) => c.drawCircle(
    p,
    r,
    Paint()
      ..shader = Gradient.radial(p, r, [
        Color(color),
        Color(color).withValues(alpha: 0),
      ]),
  );
}
