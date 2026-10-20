import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/game.dart';

import '../domain/lantern_run.dart';
import 'characters.dart';

/// Arte geométrico propio. La escena observa el dominio, nunca entrega oro.
class LanternScene extends FlameGame {
  LanternScene(this.run);

  final LanternRun run;
  bool reducedMotion = false;
  double arenaTop = 84;
  double arenaBottom = 500;
  double _time = 0;
  double _pulse = 1;
  int _seenPulses = 0;

  @override
  Color backgroundColor() => const Color(0xFF151F2B);

  @override
  void update(double dt) {
    super.update(dt);
    if (!run.running || reducedMotion) {
      _pulse = 1;
      _seenPulses = run.pulses;
      return;
    }
    _time = (_time + dt.clamp(0, 0.1)) % (math.pi * 20);
    if (_seenPulses != run.pulses) {
      _seenPulses = run.pulses;
      _pulse = 0;
    }
    _pulse = (_pulse + dt * 2).clamp(0, 1);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (size.x <= 0 || size.y <= 0) return;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = const Color(0xFF151F2B),
    );
    final arenaHeight = math.max(36.0, arenaBottom - arenaTop);
    final zoom = math.min(size.x / 560, arenaHeight / 290);
    final left = (size.x - 600 * zoom) / 2;
    final top = arenaTop + arenaHeight * .55 - 220 * zoom;
    // Escala uniforme: los personajes conservan sus proporciones.
    canvas.save();
    canvas.translate(left, top);
    canvas.scale(zoom);
    final paint = Paint();
    void rect(double x, double y, double w, double h, Color color) {
      canvas.drawRect(Rect.fromLTWH(x, y, w, h), paint..color = color);
    }

    void circle(double x, double y, double r, Color color) {
      canvas.drawCircle(Offset(x, y), r, paint..color = color);
    }

    // Galería: arcos, juntas de piedra y una ruta que gana luz.
    rect(
      -size.x / zoom,
      -size.y / zoom,
      size.x * 3 / zoom,
      size.y * 3 / zoom,
      const Color(0xFF151F2B),
    );
    for (var i = 0; i < 4; i++) {
      final x = 28.0 + i * 160;
      final arch = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, 38, 116, 245),
        const Radius.circular(58),
      );
      canvas.drawRRect(arch, paint..color = const Color(0xFF27323F));
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x + 12, 51, 92, 232),
          const Radius.circular(46),
        ),
        paint..color = const Color(0xFF111A25),
      );
    }
    rect(
      -size.x / zoom,
      278,
      size.x * 3 / zoom,
      size.y / zoom,
      const Color(0xFF303A42),
    );
    rect(-size.x / zoom, 278, size.x * 3 / zoom, 4, const Color(0xFF66716C));
    for (var i = 0; i < 10; i++) {
      rect(i * 72.0 - 20, 310, 60, 2, const Color(0xFF424D54));
      rect(i * 72.0 + 10, 340, 50, 2, const Color(0xFF424D54));
    }
    for (var i = 0; i < 3; i++) {
      final x = 140.0 + i * 160;
      final lit = i < run.litLanterns;
      rect(x, 110, 3, 44, const Color(0xFF647078));
      if (lit) {
        circle(x + 1, 171, 36, const Color(0x18FFD18A));
        circle(x + 1, 171, 23, const Color(0x24FFD18A));
      }
      rect(x - 9, 153, 22, 29, const Color(0xFF717D80));
      rect(
        x - 5,
        158,
        14,
        19,
        lit ? const Color(0xFFFFD18A) : const Color(0xFF323B49),
      );
    }
    const amber = Color(0xFFFFD18A);
    final action = reducedMotion ? 0.0 : math.sin(_pulse * math.pi);
    Characters.keeper(canvas, action: action);
    Characters.sootling(
      canvas,
      bob: reducedMotion || !run.running ? 0 : math.sin(_time * 2) * 3,
      hit: action,
    );
    if (_pulse < 1 && !reducedMotion) {
      final x = 236 + _pulse * 180;
      circle(x, 223, 9 - _pulse * 3, amber.withValues(alpha: 1 - _pulse));
    }
    // Motes ambientales deterministas, sin generar partículas acumulables.
    for (var i = 0; i < 12; i++) {
      circle(
        24 + i * 49.0,
        70 + (i * 37 % 180).toDouble(),
        1.5,
        const Color(0xFF56616D),
      );
    }
    canvas.restore();
  }
}
