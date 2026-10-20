import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'domain/lantern_run.dart';
import 'presentation/lantern_scene.dart';
import 'presentation/rpg_view.dart';
import 'data/save_gate.dart';
import 'data/save_repository.dart';
import 'presentation/settings.dart';
import 'presentation/game_sound.dart';
import 'presentation/game_theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.run, this.textScaler});
  final LanternRun? run;
  final TextScaler? textScaler;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Farol de Ceniza',
    debugShowCheckedModeBanner: false,
    theme: GameStyle.theme(),
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: run != null || textScaler != null
        ? RunScreen(run: run)
        : SaveGate(
            builder: (saved, repository, clock, status) =>
                RunScreen(run: saved, repository: repository),
          ),
  );
}

class RunScreen extends StatefulWidget {
  const RunScreen({super.key, this.run, this.repository});
  final LanternRun? run;
  final SaveRepository? repository;
  @override
  State<RunScreen> createState() => _RunScreenState();
}

class _RunScreenState extends State<RunScreen> with WidgetsBindingObserver {
  final Stopwatch _clock = Stopwatch();
  late LanternRun _run;
  late final LanternScene _scene;
  late final Timer _timer;
  int _tab = 0;
  int _saveSequence = 0;
  Duration _lastCheckpoint = Duration.zero;
  Timer? _hold;
  final GameSound _sound = GameSound();
  String _saveStatus = 'Sesión de prueba';
  bool _saveFailed = false;

  void _persist() {
    final repo = widget.repository;
    if (repo == null) return;
    final sequence = ++_saveSequence;
    _saveStatus = 'Guardando…';
    unawaited(
      repo
          .save(_run.toJson())
          .then((_) {
            if (mounted && sequence == _saveSequence) {
              setState(() => _saveStatus = 'Guardado');
            }
          })
          .catchError((Object e) {
            _saveFailed = true;
            _run.setActive(false);
            if (mounted) setState(() => _saveStatus = 'Error de guardado: $e');
          }),
    );
  }

  void _selectTab(int value) {
    _hold?.cancel();
    setState(() {
      _tab = value;
      _run.setActive(
        !_saveFailed &&
            value == 0 &&
            (WidgetsBinding.instance.lifecycleState == null ||
                WidgetsBinding.instance.lifecycleState ==
                    AppLifecycleState.resumed),
      );
    });
  }

  String _message = 'Cuatro ataques cargan una llamarada de triple daño.';

  @override
  void initState() {
    super.initState();
    _clock.start();
    _run = widget.run ?? LanternRun(now: () => _clock.elapsed);
    _scene = LanternScene(_run);
    final state = WidgetsBinding.instance.lifecycleState;
    _run.setActive(state == null || state == AppLifecycleState.resumed);
    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      final victories = _run.victories;
      final completed = _run.completed;
      final encounterState = _run.encounterState;
      final strikes = _run.enemyStrikes;
      if (_run.sample()) {
        if (_run.sound && _run.enemyStrikes != strikes && _run.lastBlocked) {
          unawaited(_sound.play('block'));
        }
        if (_run.encounterState != encounterState ||
            _run.victories != victories ||
            _clock.elapsed - _lastCheckpoint >= const Duration(seconds: 2)) {
          _lastCheckpoint = _clock.elapsed;
          _persist();
        }
        setState(() {
          if (!completed && _run.completed) {
            _message = 'La ruta vuelve a brillar. Tres faroles encendidos.';
          } else if (_run.victories != victories) {
            _message = '+2 de oro · Criatura disipada.';
          }
        });
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _hold?.cancel();
    _run.setActive(
      !_saveFailed && state == AppLifecycleState.resumed && _tab == 0,
    );
    unawaited(_sound.stop());
    _persist();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();
    _hold?.cancel();
    _clock.stop();
    unawaited(_sound.dispose());
    super.dispose();
  }

  void _upgrade() {
    if (!_run.buyUpgrade()) return;
    _persist();
    if (_run.vibration && !MediaQuery.disableAnimationsOf(context)) {
      HapticFeedback.lightImpact();
    }
    setState(() => _message = 'Mecha reforzada · Daño ${_run.damage}');
  }

  void _attack({bool flare = false}) {
    final victories = _run.victories;
    final level = _run.level;
    final completed = _run.completed;
    if (!(flare ? _run.flare() : _run.attack())) return;
    if (_run.sound) {
      unawaited(
        _sound.play(
          _run.level > level
              ? 'level'
              : _run.victories != victories
              ? 'reward'
              : flare
              ? 'flare'
              : 'attack',
        ),
      );
    }
    _persist();
    setState(() {
      _message = !completed && _run.completed
          ? 'La ruta vuelve a brillar. Tres faroles encendidos.'
          : _run.victories != victories
          ? '+2 de oro · Criatura disipada.'
          : flare
          ? '¡Llamarada! Triple daño.'
          : _run.charge == 4
          ? 'Llamarada lista. Tú decides cuándo usarla.'
          : 'Pulso de luz · Carga ${_run.charge}/4';
    });
  }

  @override
  Widget build(BuildContext context) {
    _scene.reducedMotion =
        _run.reducedMotion || MediaQuery.disableAnimationsOf(context);
    return RpgView(
      run: _run,
      scene: _scene,
      tab: _tab,
      onTab: _selectTab,
      onAttack: _attack,
      onFlare: () => _attack(flare: true),
      onUpgrade: _upgrade,
      onPause: () {
        _hold?.cancel();
        setState(_run.togglePause);
        _persist();
      },
      onAuto: () {
        setState(_run.toggleAutoAttack);
        _persist();
      },
      onAct: (action) {
        if (_saveFailed) return;
        final gold = _run.gold;
        final mana = _run.mana;
        final level = _run.level;
        setState(action);
        if (_run.sound) {
          if (_run.gold < gold) {
            unawaited(_sound.play('purchase'));
          } else if (_run.level > level) {
            unawaited(_sound.play('level'));
          } else if (_run.mana < mana) {
            unawaited(
              _sound.play(
                _run.lastAction == 'cura'
                    ? 'heal'
                    : _run.lastAction == 'hielo'
                    ? 'ice'
                    : 'flare',
              ),
            );
          }
        }
        _persist();
      },
      onHoldStart: () {
        if (!_run.running) return;
        _hold?.cancel();
        _hold = Timer.periodic(
          const Duration(milliseconds: 350),
          (_) => _attack(),
        );
      },
      onHoldEnd: () => _hold?.cancel(),
      onSettings: () async {
        _hold?.cancel();
        _run.setActive(false);
        final replacement = await showRunSettings(
          context,
          _run,
          widget.repository,
          () {
            if (!_run.sound) unawaited(_sound.stop());
            setState(() {});
            _persist();
          },
        );
        if (mounted) {
          setState(() {
            if (replacement != null) {
              _run = LanternRun.fromLegacy(replacement, now: _run.now);
              _scene.run = _run;
            }
            _run.setActive(!_saveFailed && _tab == 0);
          });
        }
      },
      message: '$_message · $_saveStatus',
    );
  }
}
