import 'package:flutter/material.dart' hide Characters, FilledButton;

import 'game_controls.dart';

import 'hero_art.dart';
import 'game_theme.dart';
import 'game_badge.dart';

class TitleScreen extends StatelessWidget {
  const TitleScreen({super.key, required this.onContinue});
  final VoidCallback onContinue;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: [
        const RepaintBoundary(child: CustomPaint(painter: _CoverPainter())),
        SafeArea(
          child: LayoutBuilder(
            builder: (context, c) => SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: c.maxHeight - 56),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 24),
                        const GameBadge(
                          icon: Icons.local_fire_department_rounded,
                          color: GameStyle.gold,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'UNA LUZ CONTRA LA OSCURIDAD',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: GameStyle.teal,
                            fontSize: 11,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'FAROL DE\nCENIZA',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                fontSize: 46,
                                color: GameStyle.gold,
                                shadows: const [
                                  Shadow(
                                    color: Colors.black54,
                                    blurRadius: 14,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Restaura tres faroles y abre el Umbral.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 280),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 360),
                        child: GamePanel(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              FilledButton.icon(
                                onPressed: onContinue,
                                icon: const Icon(Icons.play_arrow_rounded),
                                label: const Text('Continuar'),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Tu aventura se guarda en este dispositivo.\nSin cuentas ni anuncios.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: GameStyle.muted,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _CoverPainter extends CustomPainter {
  const _CoverPainter();
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF101B32), Color(0xFF354768), Color(0xFF0B202B)],
        ).createShader(Offset.zero & size),
    );
    for (var i = 0; i < 28; i++) {
      canvas.drawCircle(
        Offset(
          (i * 89 % 397) / 397 * size.width,
          (i * 53 % 300) / 500 * size.height,
        ),
        i % 3 == 0 ? 2 : 1,
        Paint()..color = const Color(0x8878B5BA),
      );
    }
    final scale = (size.width / 260).clamp(.8, 2.0);
    canvas.save();
    canvas.translate(
      size.width / 2 - 160 * scale,
      size.height * .57 - 220 * scale,
    );
    canvas.scale(scale);
    HeroArt.paint(canvas, 'farol', 0);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_CoverPainter oldDelegate) => false;
}
