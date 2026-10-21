import 'package:flutter/material.dart'
    hide FilledButton, OutlinedButton, TextButton;

import 'package:flame/game.dart';

import 'game_controls.dart';
import 'game_theme.dart';
import 'kenney_asset_gallery.dart';

/// Review screen for selected CC0 sprites, reachable by holding the HUD portrait.
class KenneyAssetGalleryView extends StatelessWidget {
  const KenneyAssetGalleryView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: GameStyle.ink,
    appBar: AppBar(
      title: const Text('Galería de assets CC0'),
      leading: TextButton(
        onPressed: () => Navigator.maybePop(context),
        child: const Text('‹'),
      ),
    ),
    body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Text(
              'Kenney · Toon Characters + RPG Base · CC0\n'
              'Guardianes y suelo de piedra ya aparecen en combate.',
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(child: GameWidget(game: KenneyAssetGallery())),
        ],
      ),
    ),
  );
}
