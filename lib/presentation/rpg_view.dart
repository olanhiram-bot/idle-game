import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../domain/lantern_run.dart';
import 'lantern_scene.dart';

class RpgView extends StatelessWidget {
  const RpgView({
    super.key,
    required this.run,
    required this.scene,
    required this.tab,
    required this.onTab,
    required this.onAttack,
    required this.onFlare,
    required this.onUpgrade,
    required this.onPause,
    required this.onAuto,
    required this.message,
  });
  final LanternRun run;
  final LanternScene scene;
  final int tab;
  final ValueChanged<int> onTab;
  final VoidCallback onAttack, onFlare, onUpgrade, onPause, onAuto;
  final String message;

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
    final insets = MediaQuery.paddingOf(context);
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final dockHeight = math.min(
            height * (height < 500 ? .60 : .38),
            scale > 1.4 ? 340.0 : 288.0,
          );
          final arenaTop = insets.top + (scale > 1.4 ? 112.0 : 84.0);
          final arenaBottom = height - dockHeight - insets.bottom;
          scene.arenaTop = arenaTop;
          scene.arenaBottom = math.max(arenaTop + 36, arenaBottom);
          final arenaHeight = scene.arenaBottom - arenaTop;
          final zoom = math.min(constraints.maxWidth / 560, arenaHeight / 290);
          final sceneLeft = (constraints.maxWidth - 600 * zoom) / 2;
          final meterWidth = math.min(180.0, constraints.maxWidth * .42);
          final meterTop = math.max(
            arenaTop,
            arenaTop + arenaHeight * .55 - 66 * zoom - 54 * scale,
          );
          return Stack(
            fit: StackFit.expand,
            children: [
              Semantics(
                button: true,
                label: 'Atacar criatura de hollín',
                onTap: run.running ? onAttack : null,
                child: GestureDetector(
                  onTap: run.running ? onAttack : null,
                  child: ExcludeSemantics(child: GameWidget(game: scene)),
                ),
              ),
              Positioned(
                top: insets.top + 8,
                left: insets.left + 12,
                right: insets.right + 12,
                child: _plate(
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Farol de Ceniza',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                run.completed
                                    ? 'Ruta restaurada · 3/3'
                                    : 'Galería · Tramo ${run.stage + 1}/3',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFCCD4D9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${run.gold} oro',
                          style: const TextStyle(
                            color: Color(0xFFFFD18A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          tooltip: run.paused ? 'Reanudar' : 'Pausar',
                          onPressed: onPause,
                          icon: Icon(
                            run.paused ? Icons.play_arrow : Icons.pause,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (scene.arenaBottom - arenaTop > 160) ...[
                Positioned(
                  top: meterTop,
                  left: (sceneLeft + 430 * zoom - meterWidth / 2).clamp(
                    12.0,
                    constraints.maxWidth - meterWidth - 12,
                  ),
                  width: meterWidth,
                  child: _meter(
                    key: const Key('enemy-health'),
                    label: 'Vida · ${run.enemyHealth}/${run.maxHealth}',
                    value: run.enemyHealth / run.maxHealth,
                    color: const Color(0xFFE58B85),
                  ),
                ),
                Positioned(
                  top: meterTop,
                  left: (sceneLeft + 160 * zoom - meterWidth / 2).clamp(
                    12.0,
                    constraints.maxWidth - meterWidth - 12,
                  ),
                  width: meterWidth,
                  child: _meter(
                    key: const Key('hero-charge'),
                    label: 'Carga · ${run.charge}/4',
                    value: run.charge / 4,
                    color: const Color(0xFFFFD18A),
                  ),
                ),
              ] else
                Positioned(
                  top: arenaTop,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      Expanded(
                        child: _meter(
                          key: const Key('hero-charge'),
                          label: 'Carga ${run.charge}/4',
                          value: run.charge / 4,
                          color: const Color(0xFFFFD18A),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _meter(
                          key: const Key('enemy-health'),
                          label: 'Vida ${run.enemyHealth}/${run.maxHealth}',
                          value: run.enemyHealth / run.maxHealth,
                          color: const Color(0xFFE58B85),
                        ),
                      ),
                    ],
                  ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  key: const Key('command-panel'),
                  height: dockHeight + insets.bottom,
                  decoration: const BoxDecoration(
                    color: Color(0xF5111925),
                    border: Border(top: BorderSide(color: Color(0xFF8D795B))),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            key: PageStorageKey('menu-$tab'),
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 720,
                                ),
                                child: _menu(context),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          key: const Key('bottom-tabs'),
                          height: scale > 1.4 ? 100 : 64,
                          child: Row(
                            children: [
                              _tab(0, 'Combate', Icons.flash_on),
                              _tab(
                                1,
                                'Mecha',
                                Icons.local_fire_department_outlined,
                              ),
                              _tab(2, 'Ruta', Icons.route_outlined),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (run.paused)
                Positioned(
                  top: arenaTop + 2,
                  left: 12,
                  child: _plate(
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('EN PAUSA'),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _tab(int index, String label, IconData icon) => Expanded(
    child: Semantics(
      selected: tab == index,
      child: Material(
        color: tab == index ? const Color(0xFF2D302F) : Colors.transparent,
        child: InkWell(
          onTap: () => onTab(index),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 22,
                color: tab == index
                    ? const Color(0xFFFFD18A)
                    : const Color(0xFFB4C0CC),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: tab == index
                      ? const Color(0xFFFFD18A)
                      : const Color(0xFFB4C0CC),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _menu(BuildContext context) {
    if (tab == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'La mecha del farol',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'Daño ${run.damage} · Llamarada ${run.damage * 3} · Mejora ${run.upgrades}/5',
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: run.canUpgrade ? onUpgrade : null,
            child: Text(
              run.upgrades == 5
                  ? 'Mecha al máximo'
                  : 'Reforzar mecha · ${run.upgradeCost} oro',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            run.upgrades == 5
                ? 'Mecha completada.'
                : run.canUpgrade
                ? 'La mejora aumenta todos tus ataques.'
                : 'Te faltan ${run.upgradeCost - run.gold} de oro.',
          ),
        ],
      );
    }
    if (tab == 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Faroles encendidos: ${run.litLanterns}/3',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text('Victorias ${run.stageVictories}/5 · Tramo ${run.stage + 1}/3'),
          const SizedBox(height: 8),
          for (var i = 0; i < 3; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                '${i < run.litLanterns ? '◆ Encendido' : '◇ Apagado'} · Farol ${i + 1}',
              ),
            ),
          const SizedBox(height: 8),
          const Text(
            'Sin guardado todavía. Recargar reinicia la ruta. No hay progreso en segundo plano.',
            style: TextStyle(color: Color(0xFFB4C0CC)),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                run.autoAttack ? 'Automático activado' : 'Modo manual',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              'Daño ${run.damage}',
              style: const TextStyle(color: Color(0xFFFFD18A)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, c) {
            final buttons = [
              FilledButton.icon(
                onPressed: run.running ? onAttack : null,
                icon: const Icon(Icons.flash_on),
                label: const Text('Atacar'),
              ),
              OutlinedButton(
                onPressed: run.canFlare ? onFlare : null,
                child: Text(
                  run.charge == 4
                      ? 'Llamarada · lista'
                      : 'Llamarada · ${run.charge}/4',
                  textAlign: TextAlign.center,
                ),
              ),
            ];
            if (MediaQuery.textScalerOf(context).scale(14) > 22 &&
                c.maxWidth < 500) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [buttons[0], const SizedBox(height: 8), buttons[1]],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: buttons[0]),
                const SizedBox(width: 10),
                Expanded(child: buttons[1]),
              ],
            );
          },
        ),
        TextButton(
          onPressed: onAuto,
          child: Text(
            run.autoAttack ? 'Volver a manual' : 'Activar automático',
          ),
        ),
        Text(
          message,
          style: const TextStyle(fontSize: 12, color: Color(0xFFCCD4D9)),
        ),
      ],
    );
  }

  Widget _plate(Widget child) => DecoratedBox(
    decoration: BoxDecoration(
      color: const Color(0xEE111A27),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xFF4C5360)),
    ),
    child: child,
  );

  Widget _meter({
    required Key key,
    required String label,
    required double value,
    required Color color,
  }) => Container(
    key: key,
    padding: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: const Color(0xEE111A27),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: const Color(0xFF626271)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value,
          minHeight: 6,
          color: color,
          backgroundColor: const Color(0xFF34333C),
          semanticsLabel: label,
        ),
      ],
    ),
  );
}
