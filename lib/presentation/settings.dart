import 'dart:convert';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart'
    hide FilledButton, OutlinedButton, TextButton, SwitchListTile;

import 'game_controls.dart';
import 'game_dialog.dart';

import '../domain/lantern_run.dart';
import '../data/save_repository.dart';
import 'game_theme.dart';
import 'game_badge.dart';

Future<Map<String, Object?>?> showRunSettings(
  BuildContext context,
  LanternRun run,
  SaveRepository? repo,
  VoidCallback refresh,
) async {
  return showModalBottomSheet<Map<String, Object?>>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setLocal) {
        void change(VoidCallback action) {
          action();
          refresh();
          setLocal(() {});
        }

        Future<void> export() async {
          final location = await getSaveLocation(suggestedName: 'farol.json');
          if (location == null) return;
          await XFile.fromData(
            Uint8List.fromList(utf8.encode(jsonEncode(run.toJson()))),
            mimeType: 'application/json',
            name: 'farol.json',
          ).saveTo(location.path);
        }

        return SafeArea(
          child: SizedBox(
            height: MediaQuery.sizeOf(ctx).height * .85,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: GameBadge(
                      key: Key('settings-emblem'),
                      icon: Icons.settings_rounded,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const SectionHeading(
                    'Ajustes y respaldo',
                    'Tu aventura, a tu manera. Tus datos, en tu dispositivo.',
                  ),
                  SwitchListTile(
                    title: const Text('Sonido'),
                    secondary: const Icon(
                      Icons.volume_up_rounded,
                      color: GameStyle.teal,
                    ),
                    value: run.sound,
                    onChanged: (v) => change(() => run.sound = v),
                  ),
                  SwitchListTile(
                    title: const Text('Vibración'),
                    secondary: const Icon(
                      Icons.vibration_rounded,
                      color: GameStyle.gold,
                    ),
                    value: run.vibration,
                    onChanged: (v) => change(() => run.vibration = v),
                  ),
                  SwitchListTile(
                    title: const Text('Reducir movimiento'),
                    secondary: const Icon(
                      Icons.accessibility_new_rounded,
                      color: GameStyle.teal,
                    ),
                    value: run.reducedMotion,
                    onChanged: (v) => change(() => run.reducedMotion = v),
                  ),
                  SwitchListTile(
                    title: const Text(
                      'Protección accesible · ventana ampliada',
                    ),
                    value: run.assistance,
                    secondary: const Icon(
                      Icons.shield_outlined,
                      color: GameStyle.gold,
                    ),
                    onChanged: (v) => change(() => run.assistance = v),
                  ),
                  const GamePanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GUÍA DEL GUARDAFAROLES',
                          style: TextStyle(
                            color: GameStyle.gold,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Cómo jugar: elige un encuentro, mantén Atacar, espera la señal para Proteger y usa Llamarada cuando la coraza se abra. Gana oro, mejora la mecha y elige dos módulos fuera del combate. Cinco victorias restauran cada farol. El jefe abre la ruta.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () async {
                      try {
                        await export();
                      } catch (e) {
                        if (ctx.mounted) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(content: Text('No se pudo exportar: $e')),
                          );
                        }
                      }
                    },
                    child: const Text('Exportar partida'),
                  ),
                  OutlinedButton(
                    onPressed: repo == null
                        ? null
                        : () async {
                            try {
                              final file = await openFile(
                                acceptedTypeGroups: [
                                  const XTypeGroup(
                                    label: 'JSON',
                                    extensions: ['json'],
                                  ),
                                ],
                              );
                              if (file == null) return;
                              if (await file.length() > 1048576) {
                                throw const FormatException('Máximo 1 MiB');
                              }
                              final raw = jsonDecode(await file.readAsString());
                              final imported = repo.validate(raw);
                              final candidate = LanternRun.fromJson(
                                imported,
                                now: () => Duration.zero,
                              );
                              if (!ctx.mounted) return;
                              final yes = await showDialog<bool>(
                                context: ctx,
                                builder: (c) => GameDialog(
                                  title: const Text('¿Reemplazar partida?'),
                                  content: Text(
                                    '${candidate.gold} oro · ${candidate.victories} victorias. Se conservará la partida actual como respaldo. Recarga después de importar.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(c, false),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(c, true),
                                      child: const Text('Importar'),
                                    ),
                                  ],
                                ),
                              );
                              if (yes == true) {
                                await repo.importJson(jsonEncode(imported));
                                if (ctx.mounted) Navigator.pop(ctx, imported);
                              }
                            } catch (e) {
                              if (ctx.mounted) {
                                ScaffoldMessenger.of(ctx).showSnackBar(
                                  SnackBar(
                                    content: Text('Importación rechazada: $e'),
                                  ),
                                );
                              }
                            }
                          },
                    child: const Text(
                      'Importar partida · reemplaza, no fusiona',
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: repo == null
                        ? null
                        : () async {
                            final yes = await showDialog<bool>(
                              context: ctx,
                              builder: (c) => GameDialog(
                                title: const Text('¿Nueva partida?'),
                                content: const Text(
                                  'Se conservará la actual como respaldo antes de empezar de nuevo.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(c, false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(c, true),
                                    child: const Text('Crear partida'),
                                  ),
                                ],
                              ),
                            );
                            if (yes != true) return;
                            final fresh = LanternRun(
                              now: () => Duration.zero,
                              campaign: true,
                            ).toJson();
                            await repo.save(fresh);
                            if (ctx.mounted) Navigator.pop(ctx, fresh);
                          },
                    child: const Text('Nueva partida · conservar respaldo'),
                  ),
                  const Text(
                    'Créditos: personajes, escenario y efectos son originales de este proyecto. Flutter y Flame y las demás dependencias conservan sus respectivas licencias. Sin cuentas, compras ni anuncios.',
                  ),
                  const Text(
                    'Guardado local: borrar datos del navegador o desinstalar puede eliminar la partida. Exporta una copia. No hay progreso offline.',
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Volver al juego'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
