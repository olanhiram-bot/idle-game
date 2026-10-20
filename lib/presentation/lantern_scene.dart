import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/game.dart';

import '../domain/lantern_run.dart';
import 'enemy_art.dart';
import 'arena_layout.dart';
import 'world_art.dart';
import 'hero_art.dart';

/// Arte geométrico propio. La escena observa el dominio, nunca entrega oro.
class LanternScene extends FlameGame {
  LanternScene(this.run);

  LanternRun run;
  bool reducedMotion = false;
  double arenaTop = 84;
  double arenaBottom = 500;
  double _time = 0;
  double _pulse = 1;
  int _seenPulses = 0;
  int _seenStrikes = 0;
  double _enemyPulse = 1;
  double get attackProgress => _pulse;

  @override
  Color backgroundColor() => const Color(0xFF151F2B);

  @override
  void update(double dt) {
    super.update(dt);
    if (run.paused || reducedMotion) {
      _pulse = 1;
      _seenPulses = run.pulses;
      _enemyPulse = 1;
      _seenStrikes = run.enemyStrikes;
      return;
    }
    _time = (_time + dt.clamp(0, 0.1)) % (math.pi * 20);
    if (_seenPulses != run.pulses) {
      _seenPulses = run.pulses;
      _pulse = 0;
    }
    _pulse = (_pulse + dt * 2).clamp(0, 1);
    if (_seenStrikes != run.enemyStrikes) {
      _seenStrikes = run.enemyStrikes;
      _enemyPulse = 0;
    }
    _enemyPulse = (_enemyPulse + dt * 2).clamp(0, 1);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (size.x <= 0 || size.y <= 0) return;
    WorldArt.paint(
      canvas,
      Size(size.x, size.y),
      sector: run.campaign ? run.encounter : 0,
      litLanterns: run.litLanterns,
    );
    final layout = ArenaLayout(
      width: size.x,
      top: arenaTop,
      bottom: arenaBottom,
    );
    final zoom = layout.zoom;
    final left = layout.left;
    final top = layout.originY;
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

    // Plataforma compartida por personajes; el mundo permanece a pantalla completa.
    canvas.drawOval(
      const Rect.fromLTWH(36, 258, 530, 58),
      Paint()..color = const Color(0xFF18343D),
    );
    canvas.drawArc(
      const Rect.fromLTWH(36, 250, 530, 52),
      0,
      math.pi,
      false,
      Paint()
        ..color = const Color(0xFF65877D)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
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
    canvas.save();
    canvas.translate(action * 48, 0);
    final incoming = reducedMotion ? 0.0 : math.sin(_enemyPulse * math.pi);
    HeroArt.paint(
      canvas,
      run.heroId,
      action,
      defending: run.protectionMs > 0,
      hurt: run.lastBlocked ? 0 : incoming,
      defeated: run.defeated,
    );
    canvas.restore();
    if (run.campaign && run.protectionMs > 0) {
      canvas.drawOval(
        const Rect.fromLTWH(114, 154, 94, 140),
        Paint()
          ..color = const Color(0x997BD8D2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4,
      );
    }
    canvas.save();
    canvas.translate(-math.sin(_enemyPulse * math.pi) * 40, 0);
    EnemyArt.paint(
      canvas,
      run.campaign ? run.encounter : 0,
      attack: reducedMotion ? 0 : math.sin(_enemyPulse * math.pi),
      hit: action,
    );
    canvas.restore();
    if (_pulse < 1 && !reducedMotion) {
      final x = 236 + _pulse * 180;
      final special = run.lastAction == 'flare';
      circle(
        x,
        223,
        (special ? 28 : 12) - _pulse * 3,
        amber.withValues(alpha: 1 - _pulse),
      );
      canvas.drawArc(
        Rect.fromCircle(
          center: const Offset(270, 222),
          radius: 45 + action * 35,
        ),
        -.9,
        1.8,
        false,
        Paint()
          ..color = amber.withValues(alpha: 1 - _pulse)
          ..style = PaintingStyle.stroke
          ..strokeWidth = special ? 9 : 4,
      );
    }
    void damageLabel(String text, double x, double y, Color color) {
      final builder =
          ParagraphBuilder(
              ParagraphStyle(fontSize: 24, fontWeight: FontWeight.w900),
            )
            ..pushStyle(TextStyle(color: color))
            ..addText(text);
      final paragraph = builder.build()
        ..layout(const ParagraphConstraints(width: 180));
      canvas.drawParagraph(paragraph, Offset(x, y));
    }

    if (_pulse < 1) {
      damageLabel('-${run.lastDamage}', 414, 174 - _pulse * 28, amber);
    }
    if (_enemyPulse < 1) {
      damageLabel(
        run.lastBlocked ? 'BLOQUEO' : '-${run.lastIncomingDamage}',
        105,
        150 - _enemyPulse * 25,
        const Color(0xFFFFB4AB),
      );
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
