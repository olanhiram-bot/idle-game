import 'package:flutter/material.dart'
    hide FilledButton, OutlinedButton, TextButton;

import 'game_controls.dart';
import 'game_dialog.dart';

import '../domain/lantern_run.dart';
import '../domain/content.dart';
import 'game_theme.dart';
import 'character_view.dart';
import 'game_badge.dart';

class CampaignMenu extends StatelessWidget {
  const CampaignMenu({
    super.key,
    required this.run,
    required this.tab,
    required this.act,
    required this.attack,
    required this.flare,
    required this.settings,
    required this.holdStart,
    required this.holdEnd,
    required this.prepare,
  });
  final LanternRun run;
  final int tab;
  final void Function(VoidCallback) act;
  final VoidCallback attack, flare, settings, holdStart, holdEnd, prepare;

  static const _moduleIcons = [
    Icons.local_fire_department_rounded,
    Icons.diamond_outlined,
    Icons.shield_outlined,
    Icons.bolt_rounded,
  ];
  static const _effects = [
    '+1 de daño en cada ataque',
    'Llamarada de daño ×4',
    'Protección sin recibir daño',
    'Carga lista en tres ataques',
  ];

  @override
  Widget build(BuildContext context) {
    if (tab == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeading(
            'El taller del farol',
            'Forja tu luz. Elige cómo afrontar la oscuridad.',
          ),
          OutlinedButton.icon(
            onPressed: run.encounterState == 'active'
                ? null
                : () async {
                    final id = await Navigator.push<String>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CharacterView(run: run),
                      ),
                    );
                    if (id != null && context.mounted) {
                      act(() {
                        run.selectHero(id);
                      });
                    }
                  },
            icon: const Icon(Icons.people_alt_outlined),
            label: const Text('Elegir personaje'),
          ),
          if (run.encounterState == 'active')
            const Text(
              'Termina el encuentro o vuelve al farol en Ruta para cambiar de personaje.',
            ),
          const SizedBox(height: 12),
          GamePanel(
            accent: GameStyle.teal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const GameBadge(
                      icon: Icons.favorite_rounded,
                      color: GameStyle.teal,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Vitalidad · ${run.vitality}/10',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  run.vitality == 10
                      ? 'Vida máxima ${run.maxHeroHealth} · completada'
                      : 'Vida máxima ${run.maxHeroHealth} → ${run.maxHeroHealth + 5}',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const Text(
                  '+5 de vida permanente para todos tus héroes. Compra fuera de combate.',
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: run.canBuyVitality
                      ? () => act(() {
                          run.buyVitality();
                        })
                      : null,
                  child: Text(
                    run.vitality == 10
                        ? 'Vitalidad al máximo'
                        : 'Mejorar vida · ${run.vitalityCost} oro',
                  ),
                ),
                if (run.vitality < 10 && run.gold < run.vitalityCost)
                  Text(
                    'Te faltan ${run.vitalityCost - run.gold} oro. Gana peleas o reclama encargos en Ruta.',
                    style: const TextStyle(color: GameStyle.muted),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionHeading(
            'Academia de habilidades',
            '${run.gold} oro disponible · habilidades compartidas por tus héroes',
          ),
          for (final skill in skills)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GamePanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        GameBadge(
                          key: Key('skill-emblem-${skill.id}'),
                          icon: skill.id == 'golpe'
                              ? Icons.bolt_rounded
                              : skill.id == 'cura'
                              ? Icons.favorite_rounded
                              : Icons.ac_unit_rounded,
                          color: skill.id == 'golpe'
                              ? GameStyle.gold
                              : skill.id == 'cura'
                              ? const Color(0xFF80DDA9)
                              : GameStyle.teal,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${skill.name} · Rango ${run.skillRank(skill.id)}/3',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${skill.description} · ${skill.mana} PM · 1 s de recuperación',
                    ),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: run.canBuySkill(skill)
                          ? () => act(() {
                              run.buySkill(skill.id);
                            })
                          : null,
                      child: Text(
                        run.skillRank(skill.id) == 3
                            ? '${skill.name} al máximo'
                            : '${run.skillRank(skill.id) == 0 ? 'Aprender' : 'Mejorar'} ${skill.name} · ${run.skillCost(skill)} oro',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const Text(
            'Compra fuera de combate. Si falta oro, gana encuentros o reclama encargos en Ruta.',
          ),
          const SizedBox(height: 16),

          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Text('Nivel ${run.level}/5'),
              Text('XP ${run.xp}'),
              Text('Daño ${run.damage}'),
            ],
          ),
          const SizedBox(height: 10),
          GamePanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      color: GameStyle.gold,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Mecha reforzada · ${run.upgrades}/5',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                FilledButton(
                  onPressed: run.canUpgrade
                      ? () => act(() {
                          run.buyUpgrade();
                        })
                      : null,
                  child: Text(
                    run.upgrades == 5
                        ? 'Mecha al máximo'
                        : 'Reforzar mecha · ${run.upgradeCost} oro',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'MÓDULOS · ${run.equipped.length}/2 EQUIPADOS',
            style: const TextStyle(
              color: GameStyle.teal,
              fontWeight: FontWeight.w800,
              fontSize: 11,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          for (final (i, entry) in moduleNames.entries.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GamePanel(
                padding: EdgeInsets.zero,
                accent: run.equipped.contains(entry.key)
                    ? GameStyle.teal
                    : GameStyle.edge,
                child: ListTile(
                  minVerticalPadding: 12,
                  leading: Icon(
                    _moduleIcons[i],
                    color: run.moduleUnlocked(entry.key)
                        ? GameStyle.gold
                        : GameStyle.muted,
                  ),
                  title: Text(
                    entry.value.split(' · ').first,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(_effects[i]),
                  trailing: Icon(
                    run.equipped.contains(entry.key)
                        ? Icons.check_circle
                        : run.moduleUnlocked(entry.key)
                        ? Icons.add_circle_outline
                        : Icons.lock_outline,
                    color: GameStyle.teal,
                  ),
                  onTap:
                      run.moduleUnlocked(entry.key) &&
                          run.encounterState != 'active'
                      ? () => act(() {
                          run.equip(entry.key);
                        })
                      : null,
                ),
              ),
            ),
          const Text(
            'Dos módulos. Cambia gratis en el farol, no durante una pelea.',
          ),
          const Text(
            'Brasa: inicial · Cristal: 5 XP · Guarda: primer farol · Pabilo: nivel 3.',
            style: TextStyle(color: GameStyle.muted, fontSize: 12),
          ),
          TextButton.icon(
            onPressed: settings,
            icon: const Icon(Icons.settings_outlined),
            label: const Text('Ajustes y respaldo'),
          ),
        ],
      );
    }
    if (tab == 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeading(
            'La ruta de la luz',
            'Faroles ${run.litLanterns}/3 · siguiente dificultad ${run.nextRank + 1}/101',
          ),
          Text(
            'Seleccionado: ${run.enemy.name}. Vuelve a Combate para comenzar.',
            style: const TextStyle(color: GameStyle.gold),
          ),
          for (var i = 0; i < enemies.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GamePanel(
                padding: EdgeInsets.zero,
                accent: run.encounter == i ? GameStyle.gold : GameStyle.edge,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: GameBadge(
                    key: Key('route-emblem-$i'),
                    icon: i == 3
                        ? Icons.castle_outlined
                        : Icons.local_fire_department_outlined,
                    color: run.unlocked(i) ? GameStyle.gold : GameStyle.edge,
                    size: 46,
                  ),
                  title: Text(
                    enemies[i].name,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${run.nextEnemyHealth(i)} vida · ${(enemies[i].damage / 2).ceil() + run.nextRank ~/ 8} daño\n${i < 3 ? '${run.sectorWins[i]}/5 victorias · ' : ''}${enemies[i].description}',
                      ),
                      if (i < 3)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: LinearProgressIndicator(
                            value: run.sectorWins[i] / 5,
                            minHeight: 5,
                            color: GameStyle.gold,
                            backgroundColor: GameStyle.ink,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                    ],
                  ),
                  trailing: Icon(
                    run.unlocked(i) ? Icons.chevron_right : Icons.lock_outline,
                    color: GameStyle.muted,
                  ),
                  onTap: run.unlocked(i) && run.encounterState != 'active'
                      ? () => act(() {
                          run.selectEnemy(i);
                        })
                      : null,
                ),
              ),
            ),
          if (run.encounterState == 'active')
            TextButton(
              onPressed: () async {
                final yes = await showDialog<bool>(
                  context: context,
                  builder: (c) => GameDialog(
                    title: const Text('¿Volver al farol?'),
                    content: const Text(
                      'El encuentro actual se reiniciará sin recompensa. Conservarás oro e hitos.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(c, false),
                        child: const Text('Seguir'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(c, true),
                        child: const Text('Volver'),
                      ),
                    ],
                  ),
                );
                if (yes == true) act(run.returnToCamp);
              },
              child: const Text('Abandonar encuentro'),
            ),
          const SectionHeading('Encargos', 'Pequeños hitos · 6 oro cada uno'),
          for (var i = 0; i < 3; i++)
            TextButton.icon(
              icon: Icon(
                run.claimed.contains(i) ? Icons.task_alt : Icons.card_giftcard,
              ),
              onPressed: run.questReady(i) && !run.claimed.contains(i)
                  ? () => act(() {
                      run.claimQuest(i);
                    })
                  : null,
              label: Text(
                '${['Primera criatura', 'Primera llamarada', 'Abrir el Umbral'][i]} · ${run.claimed.contains(i) ? 'Cobrado' : 'Reclamar'}',
              ),
            ),
          TextButton(
            onPressed: settings,
            child: const Text('Ajustes y respaldo'),
          ),
        ],
      );
    }
    if (run.bossDefeated && run.encounterWon) {
      return Column(
        children: [
          const GameBadge(
            icon: Icons.auto_awesome,
            color: GameStyle.gold,
            size: 64,
          ),
          const SectionHeading(
            'La ruta vuelve a brillar',
            'El Umbral está abierto. Tu luz ha vencido a la ceniza.',
          ),
          FilledButton(
            onPressed: () => act(run.returnToCamp),
            child: const Text('Seguir explorando'),
          ),
        ],
      );
    }
    if (run.encounterState != 'active') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                run.defeated
                    ? Icons.heart_broken_outlined
                    : run.encounterWon
                    ? Icons.stars_rounded
                    : Icons.local_fire_department_rounded,
                color: GameStyle.gold,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  run.defeated
                      ? 'Tu luz se ha apagado · Conservas tu oro'
                      : run.encounterWon
                      ? 'Victoria · +2 oro y +2 XP'
                      : 'El farol te espera · Nivel ${run.level}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => act(() {
              run.beginEncounter(run.encounter);
            }),
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(
              run.defeated
                  ? 'Reintentar'
                  : run.encounterWon
                  ? 'Otro encuentro'
                  : 'Comenzar encuentro',
            ),
          ),
          TextButton.icon(
            onPressed: prepare,
            icon: const Icon(Icons.handyman_outlined, size: 18),
            label: const Text('Preparar equipo'),
          ),
          Text(
            'Rival: ${run.enemy.name} · ${run.nextEnemyHealth(run.encounter)} vida · dificultad ${run.nextRank + 1}/101',
            style: const TextStyle(color: GameStyle.teal),
          ),
          const Text(
            'Elige un encuentro en Ruta o prepara tus módulos en Mecha.',
            style: TextStyle(color: GameStyle.muted, fontSize: 12),
          ),
          if (!run.tutorialSeen) ...[
            const SizedBox(height: 8),
            const Text(
              'Protege ante la señal. Guarda la llamarada para una ventana de ataque.',
              style: TextStyle(color: GameStyle.muted, fontSize: 12),
            ),
            TextButton(
              onPressed: () => act(() => run.tutorialSeen = true),
              child: const Text('Entendido · omitir ayuda'),
            ),
          ],
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(
              run.enemyIntent
                  ? Icons.warning_amber_rounded
                  : Icons.track_changes,
              size: 18,
              color: run.enemyIntent ? const Color(0xFFFFA796) : GameStyle.teal,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${run.enemy.name} · ${run.enemyIntent
                    ? '¡Ataque inminente!'
                    : run.armored
                    ? 'Coraza cerrada'
                    : 'Ventana de ataque'}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Listener(
              // Commands precede optional explanations and resource detail.
              onPointerDown: (_) => holdStart(),
              onPointerUp: (_) => holdEnd(),
              onPointerCancel: (_) => holdEnd(),
              child: FilledButton.icon(
                onPressed: run.running ? attack : null,
                icon: const GameBadge(
                  key: Key('attack-command-emblem'),
                  icon: Icons.bolt_rounded,
                  color: GameStyle.gold,
                  size: 28,
                ),
                label: const Text('Atacar'),
              ),
            ),
            OutlinedButton.icon(
              onPressed: run.canFlare ? flare : null,
              icon: const Icon(Icons.local_fire_department_rounded),
              label: Text(
                run.canFlare
                    ? 'Llamarada · lista'
                    : 'Llamarada · ${run.charge}/${run.chargeTarget}',
              ),
            ),
            OutlinedButton.icon(
              onPressed: run.running && run.protectCooldownMs == 0
                  ? () => act(() {
                      run.protect();
                    })
                  : null,
              icon: const Icon(Icons.shield_outlined),
              label: Text(
                run.protectCooldownMs > 0
                    ? 'Proteger · ${(run.protectCooldownMs / 1000).ceil()} s'
                    : 'Proteger',
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () => act(run.toggleAutoAttack),
          child: Text(
            run.autoAttack ? 'Volver a manual' : 'Activar automático',
          ),
        ),
        Text(
          'PM ${run.mana}/6 · Dificultad ${run.battleRank + 1}/101',
          style: const TextStyle(
            color: GameStyle.teal,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          'Ataque enemigo en ${(run.enemyRemainingMs / 1000).toStringAsFixed(1)} s · ${run.enemyDamage} daño',
          style: TextStyle(
            color: run.enemyIntent ? const Color(0xFFFFAB93) : GameStyle.muted,
          ),
        ),
        if (run.skillCooldownMs > 0) const Text('Habilidades recuperándose…'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final skill in skills)
              if (run.skillRank(skill.id) > 0)
                OutlinedButton(
                  onPressed: run.canUseSkill(skill)
                      ? () => act(() {
                          run.useSkill(skill.id);
                        })
                      : null,
                  child: Text('${skill.name} · ${skill.mana} PM'),
                ),
          ],
        ),
        if (skills.every((s) => run.skillRank(s.id) == 0))
          const Text(
            'Aprende habilidades con oro en Mecha. Cada encuentro empieza con 6 PM.',
          ),
        if (run.pulses > 0)
          Text(
            'Último golpe: ${run.lastDamage} · ${run.lastAction == 'flare'
                ? 'Llamarada'
                : run.lastAction == 'golpe'
                ? 'Golpe poderoso'
                : 'Ataque'}',
            style: const TextStyle(
              color: GameStyle.gold,
              fontWeight: FontWeight.w700,
            ),
          ),
        if (run.enemyStrikes > 0)
          Text(
            run.lastBlocked
                ? 'Bloqueo · ${run.lastIncomingDamage} daño recibido'
                : 'Recibiste ${run.lastIncomingDamage} daño',
            style: const TextStyle(color: GameStyle.muted),
          ),
        const Text(
          'Mantén Atacar para repetir. Guarda tu llamarada y protege ante la señal.',
          style: TextStyle(fontSize: 12, color: GameStyle.muted),
        ),
      ],
    );
  }
}
