import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'domain/lantern_run.dart';
import 'presentation/lantern_scene.dart';
import 'presentation/rpg_view.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.run, this.textScaler});
  final LanternRun? run;
  final TextScaler? textScaler;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Farol de Ceniza',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFFD18A),
        brightness: Brightness.dark,
        surface: const Color(0xFF151D27),
        primary: const Color(0xFFFFD18A),
      ),
      scaffoldBackgroundColor: const Color(0xFF0E151E),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.all(12),
        ),
      ),
    ),
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: child!,
    ),
    home: RunScreen(run: run),
  );
}

class RunScreen extends StatefulWidget {
  const RunScreen({super.key, this.run});
  final LanternRun? run;
  @override
  State<RunScreen> createState() => _RunScreenState();
}

class _RunScreenState extends State<RunScreen> with WidgetsBindingObserver {
  final Stopwatch _clock = Stopwatch();
  late final LanternRun _run;
  late final LanternScene _scene;
  late final Timer _timer;
  int _tab = 0;
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
      if (_run.sample()) {
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
    _run.setActive(state == AppLifecycleState.resumed);
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();
    _clock.stop();
    super.dispose();
  }

  void _upgrade() {
    if (!_run.buyUpgrade()) return;
    if (!MediaQuery.disableAnimationsOf(context)) HapticFeedback.lightImpact();
    setState(() => _message = 'Mecha reforzada · Daño ${_run.damage}');
  }

  void _attack({bool flare = false}) {
    final victories = _run.victories;
    final completed = _run.completed;
    if (!(flare ? _run.flare() : _run.attack())) return;
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
    _scene.reducedMotion = MediaQuery.disableAnimationsOf(context);
    return RpgView(
      run: _run,
      scene: _scene,
      tab: _tab,
      onTab: (value) => setState(() => _tab = value),
      onAttack: _attack,
      onFlare: () => _attack(flare: true),
      onUpgrade: _upgrade,
      onPause: () => setState(_run.togglePause),
      onAuto: () => setState(_run.toggleAutoAttack),
      message: _message,
    );
  }
}
