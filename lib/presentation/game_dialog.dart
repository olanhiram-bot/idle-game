import 'package:flutter/material.dart';

import 'game_theme.dart';
import 'game_badge.dart';

/// Marco propio para confirmaciones; mantiene Navigator y acciones existentes.
class GameDialog extends StatelessWidget {
  const GameDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });
  final Widget title, content;
  final List<Widget> actions;
  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: Colors.transparent,
    insetPadding: const EdgeInsets.all(24),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 440),
      child: SingleChildScrollView(
        child: GamePanel(
          accent: GameStyle.gold,
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: GameBadge(
                  icon: Icons.shield_outlined,
                  color: GameStyle.gold,
                ),
              ),
              const SizedBox(height: 14),
              DefaultTextStyle.merge(
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
                child: title,
              ),
              const SizedBox(height: 14),
              content,
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 10,
                runSpacing: 6,
                children: actions,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
