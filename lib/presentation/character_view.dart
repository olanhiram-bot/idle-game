import 'package:flutter/material.dart'
    hide FilledButton, OutlinedButton, TextButton;

import 'game_controls.dart';

import '../domain/content.dart';
import '../domain/lantern_run.dart';
import 'hero_art.dart';
import 'game_theme.dart';
import 'game_badge.dart';
import 'kenney_sprites.dart';

class CharacterView extends StatefulWidget {
  const CharacterView({super.key, required this.run});
  final LanternRun run;
  @override
  State<CharacterView> createState() => _CharacterViewState();
}

class _CharacterViewState extends State<CharacterView> {
  late String selected = widget.run.heroId;
  @override
  Widget build(BuildContext context) {
    final hero = heroes.firstWhere((h) => h.id == selected);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(76),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('‹ Volver'),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Elige tu guardián',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    hero.role.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: GameStyle.teal,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: const RadialGradient(
                        colors: [Color(0xFF345D68), GameStyle.ink],
                      ),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned(
                          top: 12,
                          left: 12,
                          child: GameBadge(
                            icon: hero.id == 'bastion'
                                ? Icons.shield
                                : hero.id == 'ascua'
                                ? Icons.local_fire_department
                                : Icons.auto_fix_high,
                          ),
                        ),
                        CustomPaint(painter: HeroPortrait(selected)),
                        const Positioned(
                          bottom: 10,
                          right: 12,
                          child: Text(
                            'GUARDIÁN',
                            style: TextStyle(
                              color: GameStyle.teal,
                              letterSpacing: 2,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    hero.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(hero.description, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: StatTile(
                          label: 'VIDA',
                          value: '${widget.run.healthFor(hero)}',
                          icon: Icons.favorite_rounded,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: StatTile(
                          label: 'DAÑO',
                          value:
                              '${hero.damage + widget.run.upgrades + (widget.run.equipped.contains('brasa') ? 1 : 0)}',
                          icon: Icons.bolt_rounded,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: StatTile(
                          label: 'NIVEL',
                          value: '${widget.run.level}',
                          icon: Icons.workspace_premium_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (final h in heroes)
                        OutlinedButton(
                          key: Key('hero-choice-${h.id}'),
                          onPressed: () => setState(() => selected = h.id),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: selected == h.id
                                ? const Color(0xFF3A4669)
                                : GameStyle.panel,
                            side: BorderSide(
                              color: selected == h.id
                                  ? GameStyle.gold
                                  : GameStyle.edge,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 68,
                                height: 90,
                                child: CustomPaint(painter: HeroPortrait(h.id)),
                              ),
                              Text(h.name),
                              Icon(
                                selected == h.id
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                size: 16,
                                color: selected == h.id
                                    ? GameStyle.gold
                                    : GameStyle.muted,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: widget.run.encounterState == 'active'
                        ? null
                        : () => Navigator.pop(context, selected),
                    child: Text('Jugar con ${hero.name}'),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Vista previa: confirma para cambiar. Tus mejoras y habilidades se conservan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: GameStyle.muted),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HeroPortrait extends CustomPainter {
  HeroPortrait(this.id) : super(repaint: KenneySprites.revision);
  final String id;
  @override
  void paint(Canvas canvas, Size size) {
    final sprite = KenneySprites.hero(id, 0);
    if (sprite != null && KenneySprites.image(sprite) != null) {
      KenneySprites.paint(canvas, sprite, Offset.zero & size);
      return;
    }
    final scale = (size.height / 185).clamp(.1, 2.0);
    canvas.save();
    canvas.translate(
      size.width / 2 - 172 * scale,
      size.height / 2 - 216 * scale,
    );
    canvas.scale(scale);
    HeroArt.paint(canvas, id, 0);
    canvas.restore();
  }

  @override
  bool shouldRepaint(HeroPortrait oldDelegate) => oldDelegate.id != id;
}
