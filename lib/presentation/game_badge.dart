import 'package:flutter/material.dart';

import 'game_theme.dart';

/// Emblema hexagonal original; la semántica pertenece al control que lo contiene.
class GameBadge extends StatelessWidget {
  const GameBadge({
    super.key,
    required this.icon,
    this.color = GameStyle.teal,
    this.size = 54,
  });
  final IconData icon;
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: CustomPaint(
      painter: _BadgePainter(color),
      child: Icon(icon, color: Colors.white, size: size * .48),
    ),
  );
}

class _BadgePainter extends CustomPainter {
  const _BadgePainter(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final path = Path()
      ..moveTo(w * .5, 2)
      ..lineTo(w - 2, h * .25)
      ..lineTo(w - 2, h * .75)
      ..lineTo(w * .5, h - 2)
      ..lineTo(2, h * .75)
      ..lineTo(2, h * .25)
      ..close();
    canvas.drawShadow(path, Colors.black, 4, true);
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: .85), const Color(0xFF253356)],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_BadgePainter oldDelegate) => color != oldDelegate.color;
}

class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });
  final String label, value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => GamePanel(
    padding: const EdgeInsets.all(10),
    child: Column(
      children: [
        Icon(icon, color: GameStyle.gold, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: GameStyle.muted,
            letterSpacing: 1,
          ),
        ),
      ],
    ),
  );
}
