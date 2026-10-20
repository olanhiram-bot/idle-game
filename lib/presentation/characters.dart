import 'dart:ui';

/// Original, hand-built vector characters in the arena's 600 × 320 space.
/// Feet stay on the original baseline so scene placement remains compatible.
abstract final class Characters {
  static void keeper(Canvas canvas, {required double action}) {
    final pose = action.clamp(0.0, 1.0);
    final ink = _CharacterInk(canvas);
    ink.ellipse(154, 284, 45, 7, 0x55040D1A);
    canvas.save();
    canvas.translate(pose * 8, -pose * 2);

    // A weighted, scalloped cape gives the little traveller a strong silhouette.
    ink.shape(
      Path()
        ..moveTo(146, 205)
        ..cubicTo(125, 213, 127, 245, 114, 267)
        ..quadraticBezierTo(128, 275, 142, 268)
        ..quadraticBezierTo(163, 281, 185, 267)
        ..cubicTo(178, 248, 184, 220, 167, 207)
        ..close(),
      0xFF163E49,
    );
    ink.path(
      Path()
        ..moveTo(128, 261)
        ..quadraticBezierTo(140, 239, 138, 220)
        ..lineTo(153, 221)
        ..lineTo(169, 267)
        ..quadraticBezierTo(153, 272, 142, 264)
        ..close(),
      0xFF245D65,
    );
    // Boots: broad toes, cuffs and a separate sole, readable at phone scale.
    for (final x in <double>[139, 167]) {
      ink.shape(
        Path()
          ..moveTo(x, 251)
          ..lineTo(x + 13, 251)
          ..lineTo(x + 14, 274)
          ..quadraticBezierTo(x + 22, 275, x + 21, 283)
          ..lineTo(x - 2, 283)
          ..close(),
        0xFF443A3C,
        width: 2.5,
      );
      ink.line(Offset(x, 281), Offset(x + 19, 281), 0xFF1B2630, 3);
      ink.line(Offset(x + 2, 267), Offset(x + 11, 266), 0xFFAF8059, 2.5);
    }
    // Tunic with a cool rim, warm reflected lantern light on its right edge.
    final tunic = Path()
      ..moveTo(141, 208)
      ..quadraticBezierTo(157, 200, 173, 211)
      ..quadraticBezierTo(179, 229, 179, 254)
      ..quadraticBezierTo(160, 264, 136, 255)
      ..quadraticBezierTo(138, 230, 141, 208)
      ..close();
    ink.gradient(tunic, const Rect.fromLTWH(132, 205, 50, 56), <Color>[
      const Color(0xFF479F9B),
      const Color(0xFF21656E),
    ]);
    ink.line(const Offset(143, 226), const Offset(140, 249), 0xFF77C4B6, 2);
    ink.line(const Offset(175, 230), const Offset(176, 248), 0xFFBAAD70, 2);
    ink.line(const Offset(139, 247), const Offset(177, 246), 0xFF543F36, 6);
    ink.rounded(const Rect.fromLTWH(153, 243, 9, 8), 2, 0xFFD9B36B);
    ink.rounded(const Rect.fromLTWH(156, 245, 4, 4), 1, 0xFF493C33);

    // Back arm, a gloved hand and a crooked brass-tipped ashwood staff.
    ink.shape(
      Path()
        ..moveTo(170, 214)
        ..quadraticBezierTo(180, 213, 186, 221)
        ..lineTo(197, 216)
        ..lineTo(202, 225)
        ..quadraticBezierTo(182, 241, 174, 231)
        ..close(),
      0xFF3D8B89,
      width: 2.5,
    );
    ink.line(const Offset(200, 280), const Offset(201, 186), 0xFF101E2A, 7);
    ink.line(const Offset(200, 279), const Offset(201, 186), 0xFF846347, 4);
    ink.line(const Offset(202, 274), const Offset(203, 192), 0xFFD0A879, 1);
    ink.stroke(
      Path()
        ..moveTo(201, 196)
        ..lineTo(201, 186)
        ..quadraticBezierTo(201, 176, 213, 178)
        ..quadraticBezierTo(223, 179, 226, 190),
      0xFFE7BE75,
      3.5,
    );
    ink.ellipse(198, 221, 6, 6, 0xFFDBA574, outline: true);
    ink.line(const Offset(196, 220), const Offset(201, 220), 0xFFF4CCA1, 1.5);
    // Leather satchel and diagonal strap sit above the tunic.
    ink.line(const Offset(143, 216), const Offset(170, 247), 0xFF142E39, 6);
    ink.line(const Offset(143, 215), const Offset(170, 246), 0xFFC29861, 3.5);
    ink.shape(
      Path()
        ..moveTo(159, 242)
        ..lineTo(176, 240)
        ..lineTo(180, 257)
        ..quadraticBezierTo(169, 263, 159, 258)
        ..close(),
      0xFF885C43,
      width: 2,
    );
    ink.line(const Offset(161, 246), const Offset(175, 244), 0xFFCA9A64, 2);
    ink.rounded(const Rect.fromLTWH(167, 246, 4, 6), 1, 0xFFEAC27B);

    // Oversized hood, asymmetrical point, curved seams and dark inner lining.
    final hood = Path()
      ..moveTo(128, 204)
      ..cubicTo(124, 180, 135, 168, 149, 154)
      ..quadraticBezierTo(153, 166, 167, 170)
      ..cubicTo(181, 176, 190, 195, 183, 213)
      ..quadraticBezierTo(169, 224, 146, 216)
      ..quadraticBezierTo(132, 214, 128, 204)
      ..close();
    ink.gradient(hood, const Rect.fromLTWH(128, 159, 54, 60), <Color>[
      const Color(0xFF63BFB0),
      const Color(0xFF287D80),
      const Color(0xFF16505F),
    ]);
    ink.stroke(
      Path()
        ..moveTo(133, 195)
        ..quadraticBezierTo(132, 180, 148, 164),
      0xFF9CD9C0,
      2,
    );
    ink.shape(
      Path()
        ..moveTo(142, 187)
        ..quadraticBezierTo(157, 175, 174, 187)
        ..quadraticBezierTo(186, 201, 174, 213)
        ..quadraticBezierTo(151, 217, 140, 203)
        ..quadraticBezierTo(137, 196, 142, 187)
        ..close(),
      0xFF112E3A,
      width: 2,
    );
    // Face turns toward the creature: brows, cheeks, nose and tiny half-smile.
    ink.shape(
      Path()
        ..moveTo(151, 186)
        ..quadraticBezierTo(164, 180, 173, 191)
        ..lineTo(175, 199)
        ..lineTo(179, 202)
        ..lineTo(174, 205)
        ..quadraticBezierTo(166, 216, 153, 207)
        ..quadraticBezierTo(146, 200, 151, 186)
        ..close(),
      0xFFEBC295,
      width: 1.8,
    );
    ink.path(
      Path()
        ..moveTo(151, 187)
        ..quadraticBezierTo(160, 181, 170, 187)
        ..lineTo(163, 190)
        ..lineTo(158, 186)
        ..lineTo(151, 194)
        ..close(),
      0xFF594236,
    );
    ink.ellipse(158, 197, 2.3, 3.5, 0xFF20323C);
    ink.ellipse(170, 197, 2.1, 3.4, 0xFF20323C);
    ink.ellipse(158.5, 195.5, .8, 1, 0xFFFFF6D8);
    ink.ellipse(170.5, 195.5, .7, .9, 0xFFFFF6D8);
    ink.line(const Offset(154, 191), const Offset(159, 190), 0xFF704B37, 1.6);
    ink.line(const Offset(167, 190), const Offset(172, 191), 0xFF704B37, 1.6);
    ink.ellipse(154, 203, 3.7, 2, 0x88CA7D65);
    ink.stroke(
      Path()
        ..moveTo(163, 206)
        ..quadraticBezierTo(167, 209, 171, 205),
      0xFF844F3F,
      1.4,
    );
    // A saffron scarf is the warm anchor linking the hero to their lantern.
    ink.shape(
      Path()
        ..moveTo(138, 210)
        ..quadraticBezierTo(153, 218, 177, 212)
        ..lineTo(179, 220)
        ..quadraticBezierTo(157, 229, 137, 219)
        ..close(),
      0xFFE1AB61,
      width: 2,
    );
    ink.shape(
      Path()
        ..moveTo(140, 219)
        ..lineTo(150, 223)
        ..lineTo(146, 242)
        ..lineTo(138, 236)
        ..close(),
      0xFFBC7C43,
      width: 1.8,
    );
    ink.line(const Offset(142, 214), const Offset(161, 218), 0xFFFFD88E, 2);

    final light = Offset(226 + pose * 3, 219 - pose * 4);
    canvas.save();
    canvas.translate(light.dx - 226, light.dy - 219);
    ink.glow(const Offset(226, 220), 46, 0x66FFC266);
    ink.stroke(
      Path()
        ..moveTo(226, 190)
        ..lineTo(226, 197),
      0xFFE5BD77,
      2,
    );
    ink.shape(
      Path()
        ..moveTo(211, 208)
        ..lineTo(216, 200)
        ..lineTo(235, 200)
        ..lineTo(242, 208)
        ..close(),
      0xFFB78246,
      width: 2.5,
    );
    final glass = Path()
      ..moveTo(214, 209)
      ..lineTo(239, 209)
      ..lineTo(235, 236)
      ..lineTo(218, 236)
      ..close();
    ink.gradient(glass, const Rect.fromLTWH(214, 209, 25, 27), <Color>[
      const Color(0xFFFFE3A0),
      const Color(0xFFE99836),
    ]);
    ink.path(
      Path()
        ..moveTo(225, 233)
        ..cubicTo(214, 227, 230, 219, 225, 213)
        ..cubicTo(240, 226, 230, 232, 225, 233)
        ..close(),
      0xFFFFF5CF,
    );
    ink.line(const Offset(215, 209), const Offset(219, 237), 0xFF8F633C, 2.5);
    ink.line(const Offset(238, 209), const Offset(234, 237), 0xFF8F633C, 2.5);
    ink.line(const Offset(212, 208), const Offset(240, 208), 0xFFF3CA80, 3);
    ink.line(const Offset(217, 237), const Offset(237, 237), 0xFF342E2B, 5);
    ink.line(const Offset(218, 236), const Offset(235, 236), 0xFFD4A460, 2);
    canvas.restore();
    canvas.restore();
  }

  static void sootling(
    Canvas canvas, {
    required double bob,
    required double hit,
  }) {
    final impact = hit.clamp(0.0, 1.0);
    final ink = _CharacterInk(canvas);
    ink.ellipse(433, 284, 43, 7, 0x55040D1A);
    canvas.save();
    canvas.translate(impact * 7, bob);
    canvas.translate(432, 264);
    canvas.scale(1 + impact * .08, 1 - impact * .1);
    canvas.translate(-432, -264);
    ink.glow(const Offset(434, 244), 52, 0x183DAAA0);
    // Ears curl like cooling smoke; unequal tips avoid a generic blob silhouette.
    final body = Path()
      ..moveTo(395, 231)
      ..cubicTo(386, 212, 384, 192, 395, 178)
      ..quadraticBezierTo(396, 198, 416, 207)
      ..quadraticBezierTo(430, 200, 446, 207)
      ..cubicTo(457, 196, 455, 185, 474, 183)
      ..quadraticBezierTo(465, 200, 473, 222)
      ..cubicTo(485, 241, 477, 261, 463, 271)
      ..quadraticBezierTo(433, 287, 407, 273)
      ..cubicTo(390, 266, 384, 247, 395, 231)
      ..close();
    ink.gradient(body, const Rect.fromLTWH(390, 183, 90, 95), <Color>[
      const Color(0xFF73818C),
      const Color(0xFF404456),
      Color.lerp(const Color(0xFF262B40), const Color(0xFFB46C70), impact)!,
    ]);
    ink.path(
      Path()
        ..moveTo(396, 189)
        ..quadraticBezierTo(398, 205, 411, 213)
        ..lineTo(400, 222)
        ..close(),
      0xFF354350,
    );
    ink.path(
      Path()
        ..moveTo(467, 192)
        ..quadraticBezierTo(457, 201, 456, 215)
        ..lineTo(467, 222)
        ..close(),
      0xFF354350,
    );
    ink.stroke(
      Path()
        ..moveTo(398, 217)
        ..quadraticBezierTo(411, 207, 419, 212)
        ..quadraticBezierTo(430, 204, 441, 213),
      0xFFA2B5B0,
      2.3,
    );
    ink.ellipse(406, 270, 10, 8, 0xFF303343, outline: true);
    ink.ellipse(458, 270, 11, 8, 0xFF303343, outline: true);
    ink.line(const Offset(402, 271), const Offset(409, 272), 0xFF657175, 1.5);
    ink.line(const Offset(454, 271), const Offset(461, 272), 0xFF657175, 1.5);
    // Pale mask and enormous ember eyes: curious, grumpy, but not threatening.
    ink.ellipse(432, 239, 32, 24, 0xFF515868);
    for (final x in <double>[414, 449]) {
      ink.ellipse(x, 239, 11, 13, 0xFF182635, outline: true);
      ink.ellipse(x - 1.5, 239.5, 6.5, 8.5, 0xFFFFCF79);
      ink.ellipse(x - 2, 241, 3, 5.5, 0xFF352F35);
      ink.ellipse(x - 3.5, 235.5, 2.1, 2.7, 0xFFFFF6D4);
      ink.ellipse(x + 3, 243, 1.2, 1.3, 0xFFFFEAAB);
    }
    ink.line(const Offset(404, 224), const Offset(417, 226), 0xFF202D3A, 3);
    ink.line(const Offset(445, 226), const Offset(456, 222), 0xFF202D3A, 3);
    ink.ellipse(403, 252, 6, 2.7, 0xFF967F85);
    ink.ellipse(462, 252, 6, 2.7, 0xFF967F85);
    ink.shape(
      Path()
        ..moveTo(427, 249)
        ..quadraticBezierTo(432, 246, 437, 249)
        ..quadraticBezierTo(433, 255, 430, 253)
        ..close(),
      0xFF1D2938,
      width: 1.3,
    );
    ink.stroke(
      Path()
        ..moveTo(421, 258)
        ..quadraticBezierTo(426, 264 - impact * 8, 432, 259)
        ..quadraticBezierTo(438, 264 - impact * 8, 443, 257),
      0xFF1D2938,
      2,
    );
    ink.path(
      Path()
        ..moveTo(440, 259)
        ..lineTo(438, 263)
        ..lineTo(436, 260)
        ..close(),
      0xFFF5D8B0,
    );
    // A few soot motes, deliberately bounded rather than a particle system.
    ink.ellipse(386, 224, 2.5, 3.2, 0x88687882);
    ink.ellipse(481, 207, 2, 2.6, 0x88768B8D);
    ink.ellipse(479, 262, 1.7, 2, 0x77768B8D);
    canvas.restore();
  }
}

final class _CharacterInk {
  _CharacterInk(this.canvas);
  final Canvas canvas;
  static const _outline = Color(0xFF101F2B);

  void path(Path path, int color) =>
      canvas.drawPath(path, Paint()..color = Color(color));

  void shape(Path path, int color, {double width = 3}) {
    this.path(path, color);
    stroke(path, _outline.toARGB32(), width);
  }

  void stroke(Path path, int color, double width) => canvas.drawPath(
    path,
    Paint()
      ..color = Color(color)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round,
  );

  void line(Offset a, Offset b, int color, double width) => stroke(
    Path()
      ..moveTo(a.dx, a.dy)
      ..lineTo(b.dx, b.dy),
    color,
    width,
  );

  void ellipse(
    double x,
    double y,
    double rx,
    double ry,
    int color, {
    bool outline = false,
  }) {
    final path = Path()
      ..addOval(
        Rect.fromCenter(center: Offset(x, y), width: rx * 2, height: ry * 2),
      );
    if (outline) {
      shape(path, color, width: 2);
    } else {
      this.path(path, color);
    }
  }

  void rounded(Rect rect, double radius, int color) => canvas.drawRRect(
    RRect.fromRectAndRadius(rect, Radius.circular(radius)),
    Paint()..color = Color(color),
  );

  void gradient(Path path, Rect bounds, List<Color> colors) {
    canvas.drawPath(
      path,
      Paint()
        ..shader = Gradient.linear(
          bounds.topLeft,
          bounds.bottomRight,
          colors,
          List<double>.generate(
            colors.length,
            (index) => index / (colors.length - 1),
          ),
        ),
    );
    stroke(path, _outline.toARGB32(), 2.7);
  }

  void glow(Offset center, double radius, int color) => canvas.drawCircle(
    center,
    radius,
    Paint()
      ..shader = Gradient.radial(center, radius, <Color>[
        Color(color),
        Color(color).withValues(alpha: 0),
      ]),
  );
}
