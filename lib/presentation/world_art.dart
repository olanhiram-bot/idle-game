import 'dart:math' as math;
import 'dart:ui';

/// Original atmospheric stage. Pure drawing: no labels, actors or game state.
/// Coordinates adapt to the viewport; all procedural detail is deterministic.
abstract final class WorldArt {
  static void paint(
    Canvas canvas,
    Size size, {
    int sector = 0,
    int litLanterns = 0,
  }) {
    if (size.isEmpty || !size.width.isFinite || !size.height.isFinite) return;
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    final world = _WorldBrush(canvas, size);
    world.sky(sector);
    world.distance(sector);
    world.ruins(sector, litLanterns.clamp(0, 3));
    world.ground();
    world.foreground();
    // Hitos por sector: hongos luminosos, cristales y puerta del Umbral.
    final brush = Paint();
    if (sector == 1) {
      for (var i = 0; i < 5; i++) {
        final x = size.width * (.08 + i * .21);
        final y = size.height * (.43 + (i % 2) * .04);
        canvas.drawLine(
          Offset(x, y),
          Offset(x, y + 25),
          brush
            ..color = const Color(0xFF8C9D92)
            ..strokeWidth = 5,
        );
        canvas.drawOval(
          Rect.fromCenter(center: Offset(x, y), width: 29, height: 12),
          brush..color = const Color(0xFF83CFB0),
        );
      }
    } else if (sector == 2) {
      for (var i = 0; i < 4; i++) {
        final x = size.width * (.07 + i * .29), y = size.height * .47;
        canvas.drawPath(
          Path()
            ..moveTo(x - 12, y)
            ..lineTo(x - 7, y - 48)
            ..lineTo(x + 7, y - 65)
            ..lineTo(x + 17, y - 14)
            ..lineTo(x + 10, y)
            ..close(),
          brush..color = const Color(0xFF8C84BD),
        );
      }
    } else if (sector == 3) {
      final rect = Rect.fromLTWH(
        size.width * .33,
        size.height * .2,
        size.width * .34,
        size.height * .3,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(60)),
        brush
          ..color = const Color(0xFF719399)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 9,
      );
      brush.style = PaintingStyle.fill;
    }
    canvas.restore();
  }
}

final class _WorldBrush {
  _WorldBrush(this.canvas, this.size);
  final Canvas canvas;
  final Size size;
  double get w => size.width;
  double get h => size.height;
  double get unit => math.min(w, h);
  Offset at(double x, double y) => Offset(x * w, y * h);
  final Paint _paint = Paint();

  void fill(Path path, int color) => canvas.drawPath(
    path,
    _paint
      ..shader = null
      ..style = PaintingStyle.fill
      ..color = Color(color),
  );

  void line(Offset a, Offset b, int color, double width) => canvas.drawLine(
    a,
    b,
    Paint()
      ..color = Color(color)
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round,
  );

  void glow(Offset center, double radius, int color) => canvas.drawCircle(
    center,
    radius,
    Paint()
      ..shader = Gradient.radial(center, radius, <Color>[
        Color(color),
        Color(color).withValues(alpha: 0),
      ]),
  );

  void sky(int sector) {
    final tint = (sector % 4) / 3;
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = Gradient.linear(
          Offset.zero,
          Offset(0, h * .76),
          <Color>[
            const Color(0xFF080F21),
            Color.lerp(const Color(0xFF172B42), const Color(0xFF263147), tint)!,
            const Color(0xFF35535B),
          ],
          <double>[0, .54, 1],
        ),
    );
    glow(at(.58, .40), unit * .69, 0x223D9B9F);
    // Restrained stars: fixed placement, no frame-to-frame random shimmer.
    for (var i = 0; i < 43; i++) {
      final x = ((i * 73 + 19) % 997) / 997;
      final y = .055 + ((i * 47 + 11) % 307) / 1000;
      canvas.drawCircle(
        at(x, y),
        unit * (i % 7 == 0 ? .002 : .001),
        Paint()..color = Color(i % 5 == 0 ? 0x88DBDEC5 : 0x446C99AD),
      );
    }
    final moon = at(.73, .205);
    final radius = unit * .055;
    glow(moon, radius * 3.6, 0x207DD4D3);
    canvas.drawCircle(moon, radius, Paint()..color = const Color(0xFFC5D6CD));
    canvas.drawCircle(
      moon + Offset(-radius * .18, -radius * .16),
      radius * .82,
      Paint()..color = const Color(0xFFE0E4CD),
    );
    for (var i = 0; i < 5; i++) {
      canvas.drawCircle(
        moon +
            Offset(
              math.cos(i * 2.1) * radius * .55,
              math.sin(i * 2.1) * radius * .49,
            ),
        radius * (.08 + (i % 3) * .035),
        Paint()..color = const Color(0x247B9E9E),
      );
    }
    // Soft horizontal cloud veils cut through the moon's halo.
    for (var i = 0; i < 3; i++) {
      final rect = Rect.fromCenter(
        center: at(.73 - i * .19, .24 + i * .075),
        width: w * .55,
        height: h * .024,
      );
      canvas.drawOval(
        rect,
        Paint()
          ..shader = Gradient.radial(rect.center, rect.width / 2, const <Color>[
            Color(0x172D6471),
            Color(0x002D6471),
          ]),
      );
    }
  }

  void distance(int sector) {
    for (var layer = 0; layer < 3; layer++) {
      final ridge = Path()..moveTo(0, h * .67);
      for (var i = 0; i <= 14; i++) {
        final x = i / 14;
        final wave = math.sin(i * 2.2 + sector * .4 + layer);
        final y = .36 + layer * .065 + wave * (.075 - layer * .015);
        ridge.lineTo(x * w, y * h);
      }
      ridge
        ..lineTo(w, h * .72)
        ..lineTo(0, h * .72)
        ..close();
      fill(ridge, <int>[0xFF294552, 0xFF223E49, 0xFF19343E][layer]);
    }
    // A distant broken watchtower belongs to the landscape, not the HUD.
    fill(
      Path()
        ..moveTo(w * .40, h * .53)
        ..lineTo(w * .41, h * .335)
        ..lineTo(w * .43, h * .335)
        ..lineTo(w * .43, h * .318)
        ..lineTo(w * .45, h * .318)
        ..lineTo(w * .45, h * .341)
        ..lineTo(w * .475, h * .331)
        ..lineTo(w * .48, h * .53)
        ..close(),
      0xFF1B3541,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * .435, h * .37, w * .012, h * .028),
        Radius.circular(unit * .009),
      ),
      Paint()..color = const Color(0xFF35545C),
    );
    // Valley mist separates the architecture from the rear mountain layers.
    canvas.drawRect(
      Rect.fromLTWH(0, h * .43, w, h * .23),
      Paint()
        ..shader = Gradient.linear(
          at(0, .43),
          at(0, .66),
          const <Color>[
            Color(0x003C7278),
            Color(0x353C7278),
            Color(0x003C7278),
          ],
          const <double>[0, .5, 1],
        ),
    );
  }

  void ruins(int sector, int litLanterns) {
    final base = h * .665;
    final archWidth = w * .265;
    final top = h * .35;
    final thickness = unit * .024;
    for (var i = 0; i < 3; i++) {
      final left = w * (.065 + i * .31);
      final rect = Rect.fromLTWH(
        left,
        top + (i == 1 ? -h * .035 : 0),
        archWidth,
        base - top + h * .05,
      );
      final arch = Path()
        ..fillType = PathFillType.evenOdd
        ..addRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(archWidth / 2)),
        )
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTRB(
              rect.left + thickness,
              rect.top + thickness,
              rect.right - thickness,
              rect.bottom + thickness,
            ),
            Radius.circular((archWidth - thickness * 2) / 2),
          ),
        );
      fill(arch, 0xFF162C37);
      canvas.drawPath(
        Path()
          ..moveTo(rect.left + thickness * .35, base)
          ..lineTo(rect.left + thickness * .35, rect.top + archWidth * .5)
          ..arcTo(
            Rect.fromLTWH(
              rect.left + thickness * .35,
              rect.top + thickness * .35,
              archWidth - thickness * .7,
              archWidth - thickness * .7,
            ),
            math.pi,
            math.pi,
            false,
          )
          ..lineTo(rect.right - thickness * .35, base),
        Paint()
          ..color = const Color(0xFF3D5358)
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(1, unit * .003),
      );
      for (var row = 0; row < 5; row++) {
        final y = base - row * h * .038;
        line(
          Offset(rect.left, y),
          Offset(rect.left + thickness, y - h * .003),
          0xFF091F2A,
          1.5,
        );
        line(
          Offset(rect.right - thickness, y),
          Offset(rect.right, y + h * .002),
          0xFF091F2A,
          1.5,
        );
      }
      // Each gate has an unmistakable amber light when restored.
      final lamp = Offset(
        rect.center.dx,
        rect.top + archWidth * .36 + h * .045,
      );
      line(
        Offset(lamp.dx, rect.top + thickness),
        lamp,
        0xFF60716A,
        math.max(1, unit * .003),
      );
      final lit = i < litLanterns;
      if (lit) {
        glow(lamp + Offset(0, unit * .014), unit * .14, 0x38F6AA4E);
        glow(Offset(lamp.dx, base), unit * .16, 0x13F6AA4E);
      }
      final body = Rect.fromCenter(
        center: lamp + Offset(0, unit * .018),
        width: unit * .026,
        height: unit * .044,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          body.inflate(unit * .005),
          Radius.circular(unit * .004),
        ),
        Paint()..color = const Color(0xFF8D7959),
      );
      canvas.drawRect(
        body,
        Paint()..color = Color(lit ? 0xFFFFCF79 : 0xFF263F47),
      );
      line(
        body.topCenter,
        body.bottomCenter,
        0xFF786348,
        math.max(1, unit * .003),
      );
    }
    // Fallen masonry, mossy crowns and hairline fractures.
    for (var i = 0; i < 7; i++) {
      final x = ((i * 137 + sector * 11) % 997) / 997;
      final rect = Rect.fromLTWH(
        w * x,
        base - unit * .025,
        unit * (.04 + i % 3 * .018),
        unit * .03,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(unit * .004)),
        Paint()..color = const Color(0xFF243C43),
      );
      line(rect.topLeft, rect.topRight, 0xFF527368, math.max(1, unit * .003));
    }
  }

  void ground() {
    final horizon = h * .655;
    canvas.drawRect(
      Rect.fromLTRB(0, horizon, w, h),
      Paint()
        ..shader = Gradient.linear(
          Offset(0, horizon),
          Offset(0, h),
          const <Color>[
            Color(0xFF344B4C),
            Color(0xFF1D3039),
            Color(0xFF0C1A28),
          ],
          <double>[0, .35, 1],
        ),
    );
    // A broad receding causeway: perspective is intentional, texture sparse.
    final road = Path()
      ..moveTo(w * .49, horizon)
      ..lineTo(w * .67, horizon)
      ..quadraticBezierTo(w * .63, h * .80, w * .94, h)
      ..lineTo(w * .05, h)
      ..quadraticBezierTo(w * .41, h * .82, w * .49, horizon)
      ..close();
    canvas.drawPath(
      road,
      Paint()
        ..shader = Gradient.linear(
          at(.5, .66),
          at(.5, 1),
          const <Color>[
            Color(0xFF49605C),
            Color(0xFF263C42),
            Color(0xFF192B37),
          ],
          const <double>[0, .5, 1],
        ),
    );
    canvas.save();
    canvas.clipPath(road);
    for (var row = 0; row < 7; row++) {
      final t = (row + 1) / 7;
      final y = horizon + (h - horizon) * t * t;
      line(Offset(0, y), Offset(w, y), 0x554E6765, math.max(1, unit * .002));
      final prev = horizon + (h - horizon) * math.pow(row / 7, 2);
      for (var col = 0; col < 6; col++) {
        final x = w * ((col + (row.isEven ? .3 : .8)) / 6);
        line(
          Offset(x, prev + 2),
          Offset(x + (x - w * .56) * .08, y - 2),
          0x4420343C,
          math.max(1, unit * .003),
        );
      }
    }
    canvas.restore();
    // Controlled gravel and tiny warm spores, not all-over visual noise.
    for (var i = 0; i < 45; i++) {
      final x = ((i * 113 + 37) % 997) / 997;
      final y = .68 + ((i * 71) % 271) / 1000;
      final depth = (y - .65) / .35;
      canvas.drawOval(
        Rect.fromCenter(
          center: at(x, y),
          width: unit * (.003 + depth * .009),
          height: unit * .003,
        ),
        Paint()..color = Color(i % 3 == 0 ? 0x445F7F75 : 0x3320313A),
      );
    }
    for (var i = 0; i < 9; i++) {
      final point = at(
        .1 + ((i * 97) % 800) / 1000,
        .5 + ((i * 31) % 170) / 1000,
      );
      glow(point, unit * .013, 0x33EDB567);
      canvas.drawCircle(
        point,
        unit * .0018,
        Paint()..color = const Color(0x99EBC886),
      );
    }
  }

  void foreground() {
    // Crooked trees frame the playable centre without closing the whole sky.
    for (final right in <bool>[false, true]) {
      canvas.save();
      if (right) {
        canvas.translate(w, 0);
        canvas.scale(-1, 1);
      }
      final trunk = Path()
        ..moveTo(-w * .05, h * .81)
        ..quadraticBezierTo(w * .045, h * .61, w * .018, h * .40)
        ..lineTo(w * .045, h * .16)
        ..lineTo(w * .068, h * .12)
        ..lineTo(w * .053, h * .40)
        ..quadraticBezierTo(w * .056, h * .56, w * .09, h * .74)
        ..lineTo(w * .15, h * .80)
        ..lineTo(w * .04, h * .77)
        ..close();
      fill(trunk, 0xFF091C28);
      final branches = Path()
        ..moveTo(w * .038, h * .40)
        ..lineTo(w * .13, h * .31)
        ..lineTo(w * .21, h * .29)
        ..moveTo(w * .13, h * .31)
        ..lineTo(w * .145, h * .23)
        ..moveTo(w * .032, h * .47)
        ..lineTo(-w * .025, h * .35);
      canvas.drawPath(
        branches,
        Paint()
          ..color = const Color(0xFF091C28)
          ..style = PaintingStyle.stroke
          ..strokeWidth = unit * .014
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
      line(at(.049, .45), at(.075, .70), 0xFF28434A, unit * .003);
      // Small grass/fern clusters along the very edge, away from actor faces.
      for (var i = 0; i < 6; i++) {
        final root = at(i * .019, .79 + (i % 2) * .045);
        for (var blade = -1; blade <= 1; blade++) {
          line(
            root,
            root + Offset(unit * blade * .017, -unit * (.025 + i % 3 * .008)),
            0xFF102B32,
            unit * .005,
          );
        }
      }
      canvas.restore();
    }
    // Transparent centre, dark perimeter: readable depth without a black panel.
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = Gradient.radial(
          at(.5, .48),
          math.max(w, h) * .73,
          const <Color>[
            Color(0x00040B16),
            Color(0x00040B16),
            Color(0x96040B16),
          ],
          <double>[0, .45, 1],
        ),
    );
  }
}
