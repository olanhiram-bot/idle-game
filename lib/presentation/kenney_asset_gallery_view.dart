import 'package:flutter/material.dart'
    hide FilledButton, OutlinedButton, TextButton;

import 'package:flame/game.dart';

import 'game_controls.dart';
import 'game_theme.dart';
import 'kenney_asset_gallery.dart';

/// Isolated review screen; does not alter combat content or saved progress.
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
              'Kenney · Toon Characters · CC0\n'
              'Previsualización de candidatas. No cambia los personajes del juego.',
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(child: GameWidget(game: KenneyAssetGallery())),
        ],
      ),
    ),
  );
}
