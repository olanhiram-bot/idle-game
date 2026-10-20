/// Simulación independiente de Flutter y de la frecuencia de renderizado.
class LanternRun {
  LanternRun({required this.now, bool autoAttack = false}) {
    _autoAttack = autoAttack;
    _last = now();
  }

  final Duration Function() now;
  late Duration _last;
  Duration _remainder = Duration.zero;
  int _enemyHealth = 4;
  int _gold = 0;
  int _victories = 0;
  int _pulses = 0;
  int _upgrades = 0;
  bool _paused = false;
  bool _active = true;
  late bool _autoAttack;
  int _charge = 0;
  Duration? _lastAttack;
  bool get autoAttack => _autoAttack;
  int get charge => _charge;
  bool get canFlare => running && _charge == 4;

  void toggleAutoAttack() {
    _autoAttack = !_autoAttack;
    _resetTime();
  }

  bool attack() {
    final current = now();
    if (!running) return false;
    if (_lastAttack != null) {
      final elapsed = current - _lastAttack!;
      if (elapsed.isNegative) {
        _lastAttack = current;
        return false;
      }
      if (elapsed < const Duration(milliseconds: 350)) return false;
    }
    _lastAttack = current;
    _charge = (_charge + 1).clamp(0, 4);
    _hit(damage);
    return true;
  }

  bool flare() {
    if (!canFlare) return false;
    _charge = 0;
    _hit(damage * 3);
    return true;
  }

  void _hit(int amount) {
    _pulses++;
    _enemyHealth -= amount;
    if (_enemyHealth <= 0) {
      _gold += 2;
      _victories++;
      _enemyHealth = maxHealth;
    }
  }

  bool get paused => _paused;
  bool get running => _active && !_paused;

  void togglePause() {
    _paused = !_paused;
    _resetTime();
  }

  void setActive(bool active) {
    _active = active;
    _resetTime();
  }

  void _resetTime() {
    _last = now();
    _remainder = Duration.zero;
  }

  int get enemyHealth => _enemyHealth;
  int get gold => _gold;
  int get victories => _victories;
  int get pulses => _pulses;
  int get damage => 1 + _upgrades;
  int get upgrades => _upgrades;
  int get upgradeCost => 6 + 4 * _upgrades;
  bool get canUpgrade => _upgrades < 5 && _gold >= upgradeCost;
  int get litLanterns => (_victories ~/ 5).clamp(0, 3);
  int get stage => litLanterns.clamp(0, 2);
  bool get completed => litLanterns == 3;
  int get completionCount => completed ? 1 : 0;
  int get stageVictories => completed ? 5 : _victories % 5;
  int get maxHealth => 4 + stage * 2;

  bool buyUpgrade() {
    if (!canUpgrade) return false;
    _gold -= upgradeCost;
    _upgrades++;
    return true;
  }

  bool sample() {
    final current = now();
    final delta = current - _last;
    _last = current;
    if (!running || !_autoAttack || delta.isNegative) {
      _remainder = Duration.zero;
      return false;
    }
    // Nunca recuperar más de un segundo por muestreo tras un bloqueo.
    _remainder += delta > const Duration(seconds: 1)
        ? const Duration(seconds: 1)
        : delta;
    var changed = false;
    while (_remainder >= const Duration(seconds: 1)) {
      _remainder -= const Duration(seconds: 1);
      _hit(damage);
      changed = true;
    }
    return changed;
  }
}
