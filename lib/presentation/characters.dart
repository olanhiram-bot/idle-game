import 'dart:ui';

/// Ilustraciones vectoriales originales; sin assets externos ni fuentes remotas.
abstract final class Characters {
  static void keeper(Canvas canvas, {required double action}) {
    canvas.save();
    canvas.translate(action * 8, 0);
    final p = Paint()..isAntiAlias = true;
    void oval(Rect r, int color) => canvas.drawOval(r, p..color = Color(color));
    void shape(List<Offset> points, int color) {
      final path = Path()..addPolygon(points, true);
      canvas.drawPath(path, p..color = Color(color));
    }

    void line(Offset a, Offset b, int color, double width) {
      canvas.drawLine(
        a,
        b,
        p
          ..color = Color(color)
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round,
      );
    }

    oval(const Rect.fromLTWH(111, 278, 100, 12), 0xFF111B27);
    // Botas y pantalón, cartera de cuero y capa con forro.
    shape(const [
      Offset(141, 247),
      Offset(154, 247),
      Offset(151, 281),
      Offset(134, 281),
      Offset(135, 274),
      Offset(142, 271),
    ], 0xFF262B38);
    shape(const [
      Offset(164, 245),
      Offset(175, 248),
      Offset(180, 278),
      Offset(192, 280),
      Offset(191, 286),
      Offset(168, 286),
    ], 0xFF33313C);
    shape(const [
      Offset(146, 195),
      Offset(170, 193),
      Offset(181, 220),
      Offset(189, 267),
      Offset(165, 259),
      Offset(145, 273),
      Offset(118, 267),
      Offset(132, 241),
    ], 0xFF263D4C);
    shape(const [
      Offset(145, 201),
      Offset(163, 198),
      Offset(173, 219),
      Offset(166, 258),
      Offset(143, 270),
      Offset(123, 264),
    ], 0xFF4F827E);
    shape(const [
      Offset(145, 210),
      Offset(150, 212),
      Offset(139, 261),
      Offset(130, 264),
    ], 0xFF70A297);
    shape(const [
      Offset(167, 211),
      Offset(181, 223),
      Offset(191, 218),
      Offset(198, 226),
      Offset(180, 237),
      Offset(162, 226),
    ], 0xFF7AADA0);
    oval(const Rect.fromLTWH(186, 217, 13, 12), 0xFFD6AC85);
    line(const Offset(138, 215), const Offset(165, 249), 0xFFB38D63, 5);
    shape(const [
      Offset(151, 239),
      Offset(171, 237),
      Offset(174, 257),
      Offset(154, 260),
    ], 0xFF8C634C);
    line(const Offset(155, 246), const Offset(168, 244), 0xFFD1AC77, 2);
    // Capucha puntiaguda, rostro y pañuelo.
    shape(const [
      Offset(129, 206),
      Offset(133, 180),
      Offset(151, 160),
      Offset(172, 174),
      Offset(184, 198),
      Offset(176, 221),
      Offset(148, 219),
    ], 0xFF74A69A);
    shape(const [
      Offset(146, 180),
      Offset(170, 182),
      Offset(179, 199),
      Offset(170, 214),
      Offset(148, 207),
      Offset(140, 197),
    ], 0xFF20333F);
    shape(const [
      Offset(154, 187),
      Offset(169, 189),
      Offset(175, 200),
      Offset(167, 209),
      Offset(154, 204),
    ], 0xFFE0BA91);
    line(const Offset(163, 196), const Offset(169, 196), 0xFF263340, 2);
    shape(const [
      Offset(140, 208),
      Offset(169, 210),
      Offset(175, 219),
      Offset(146, 224),
    ], 0xFFD8A965);
    shape(const [
      Offset(144, 219),
      Offset(147, 240),
      Offset(136, 235),
    ], 0xFFC68A56);
    // Bastón de latón y farol con estructura visible.
    line(const Offset(200, 184), const Offset(200, 282), 0xFF7B5D4E, 5);
    line(const Offset(201, 185), const Offset(226, 185), 0xFFD5B47A, 4);
    line(const Offset(226, 185), const Offset(226, 200), 0xFFD5B47A, 2);
    oval(const Rect.fromLTWH(188, 188, 75, 75), 0x12FFD18A);
    shape(const [
      Offset(209, 208),
      Offset(216, 199),
      Offset(236, 199),
      Offset(243, 208),
    ], 0xFFC39559);
    shape(const [
      Offset(214, 209),
      Offset(238, 209),
      Offset(235, 237),
      Offset(217, 237),
    ], 0xFFFFD18A);
    shape(const [
      Offset(224, 211),
      Offset(231, 211),
      Offset(229, 235),
      Offset(223, 235),
    ], 0xFFFFF0C5);
    line(const Offset(213, 208), const Offset(217, 238), 0xFFA97D50, 3);
    line(const Offset(239, 208), const Offset(235, 238), 0xFFA97D50, 3);
    line(const Offset(215, 239), const Offset(237, 239), 0xFFD1AA6D, 4);
    canvas.restore();
  }

  static void sootling(
    Canvas canvas, {
    required double bob,
    required double hit,
  }) {
    canvas.save();
    canvas.translate(hit * 7, bob);
    final p = Paint()..isAntiAlias = true;
    void oval(double x, double y, double w, double h, int color) =>
        canvas.drawOval(Rect.fromLTWH(x, y, w, h), p..color = Color(color));
    oval(385, 279 - bob, 90, 12, 0xFF131B28);
    // Orejas de humo y pequeñas patas: silueta reconocible, no nube genérica.
    final ears = Path()
      ..moveTo(393, 224)
      ..quadraticBezierTo(380, 195, 393, 175)
      ..quadraticBezierTo(407, 202, 420, 208)
      ..lineTo(445, 207)
      ..quadraticBezierTo(459, 182, 473, 184)
      ..quadraticBezierTo(466, 210, 470, 228)
      ..close();
    canvas.drawPath(ears, p..color = const Color(0xFF75617D));
    oval(391, 210, 84, 66, 0xFF51465F);
    oval(398, 211, 67, 48, 0xFF71617F);
    oval(403, 262, 20, 18, 0xFF3C344D);
    oval(443, 260, 20, 18, 0xFF3C344D);
    oval(406, 231, 14, 17, 0xFF211E32);
    oval(440, 231, 14, 17, 0xFF211E32);
    oval(409, 234, 8, 9, 0xFFFFD89D);
    oval(443, 234, 8, 9, 0xFFFFD89D);
    oval(424, 249, 12, 7, 0xFF30283E);
    oval(397, 249, 12, 5, 0xFF998096);
    oval(453, 249, 12, 5, 0xFF998096);
    canvas.restore();
  }
}
