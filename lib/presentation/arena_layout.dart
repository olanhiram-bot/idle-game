import 'dart:math' as math;
import 'dart:ui';

/// Única transformación de escenario y HUD; evita barras desalineadas.
class ArenaLayout {
  ArenaLayout({required this.width, required this.top, required this.bottom})
    : height = math.max(36.0, bottom - top),
      zoom = math.min(width / 560, math.max(36.0, bottom - top) / 290);
  final double width, top, bottom, height, zoom;
  double get left => (width - 600 * zoom) / 2;
  double get originY => top + height * .55 - 220 * zoom;
  Offset project(Offset p) => Offset(left + p.dx * zoom, originY + p.dy * zoom);
}
