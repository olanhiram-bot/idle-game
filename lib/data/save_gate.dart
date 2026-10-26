import 'dart:async';

import 'package:flutter/material.dart' hide FilledButton, TextButton;

import '../presentation/game_controls.dart';
import '../presentation/game_dialog.dart';

import 'database_native.dart' if (dart.library.js_interop) 'database_web.dart';
import 'save_repository.dart';
import 'session_owner_native.dart'
    if (dart.library.js_interop) 'session_owner_web.dart';
import '../domain/lantern_run.dart';
import '../presentation/title_screen.dart';
import '../presentation/game_badge.dart';
import '../presentation/game_theme.dart';
import '../presentation/kenney_sprites.dart';

class SaveGate extends StatefulWidget {
  const SaveGate({super.key, required this.builder});
  final Widget Function(LanternRun, SaveRepository, Duration Function(), String)
  builder;
  @override
  State<SaveGate> createState() => _SaveGateState();
}

class _SaveGateState extends State<SaveGate> {
  final clock = Stopwatch()..start();
  SaveRepository? repo;
  LanternRun? run;
  String? error;
  Timer? heartbeat;
  bool loading = true;
  bool entered = false;
  String status = 'Guardado local';

  @override
  void initState() {
    super.initState();
    unawaited(_open());
  }

  Future<void> _open() async {
    try {
      await KenneySprites.load();
      final db = await openSaveDatabase();
      repo = SaveRepository(db, owner: sessionOwner());
      if (!await repo!.acquire()) {
        throw StateError(
          'Partida abierta en otra pestaña. Ciérrala y recarga.',
        );
      }
      final data = await repo!.load();
      run = data == null
          ? LanternRun(now: () => clock.elapsed, campaign: true)
          : LanternRun.fromLegacy(data, now: () => clock.elapsed);
      if (data == null || data['campaign'] != true) {
        await repo!.save(run!.toJson());
      }
      heartbeat = Timer.periodic(const Duration(seconds: 5), (_) async {
        try {
          await repo!.renew();
        } catch (e) {
          run?.setActive(false);
          if (mounted) {
            setState(() {
              error = '$e';
              status = 'Guardado detenido';
            });
          }
        }
      });
    } catch (e) {
      error = '$e';
    }
    if (mounted) setState(() => loading = false);
  }

  Future<void> _recover() async {
    try {
      await repo!.restoreBackup();
      final data = await repo!.load();
      run = LanternRun.fromJson(data!, now: () => clock.elapsed);
      heartbeat?.cancel();
      heartbeat = Timer.periodic(const Duration(seconds: 5), (_) {
        unawaited(
          repo!.renew().catchError((Object e) {
            run?.setActive(false);
            if (mounted) setState(() => error = '$e');
          }),
        );
      });
      if (mounted) setState(() => error = null);
    } catch (e) {
      if (mounted) {
        setState(
          () => error = 'No se pudo recuperar: $e. Los datos se conservan.',
        );
      }
    }
  }

  @override
  void dispose() {
    heartbeat?.cancel();
    clock.stop();
    if (repo != null) unawaited(repo!.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GameBadge(
                icon: Icons.local_fire_department_rounded,
                color: GameStyle.gold,
                size: 64,
              ),
              SizedBox(height: 20),
              Text('Encendiendo tu aventura…'),
              SizedBox(height: 16),
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
    }
    if (error != null) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: GameBadge(
                      icon: Icons.shield_outlined,
                      color: GameStyle.gold,
                      size: 64,
                    ),
                  ),
                  const Text(
                    'Tu partida está protegida',
                    style: TextStyle(fontSize: 22),
                  ),
                  const SizedBox(height: 16),
                  Text(error!),
                  const Text(
                    'No se borrarán datos ni se creará una partida vacía.',
                  ),
                  if (repo != null)
                    FilledButton(
                      onPressed: () async {
                        final ok = await showDialog<bool>(
                          context: context,
                          builder: (c) => GameDialog(
                            title: const Text('¿Restaurar la copia anterior?'),
                            content: const Text(
                              'Puede retroceder el progreso. El contenido actual se conservará en cuarentena.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(c, false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(c, true),
                                child: const Text('Restaurar'),
                              ),
                            ],
                          ),
                        );
                        if (ok == true) await _recover();
                      },
                      child: const Text('Recuperar respaldo'),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    if (!entered) {
      return TitleScreen(onContinue: () => setState(() => entered = true));
    }
    return widget.builder(run!, repo!, () => clock.elapsed, status);
  }
}
