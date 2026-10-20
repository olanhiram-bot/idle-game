import 'content.dart';

/// Simulación independiente de Flutter y de la frecuencia de renderizado.
class LanternRun {
  LanternRun({
    required this.now,
    bool autoAttack = false,
    this.campaign = false,
  }) {
    _autoAttack = autoAttack;
    _last = now();
    if (campaign) _enemyHealth = enemy.health;
  }

  final Duration Function() now;
  factory LanternRun.fromLegacy(
    Map<String, Object?> json, {
    required Duration Function() now,
  }) {
    final old = LanternRun.fromJson(json, now: now);
    if (old.campaign) return old;
    final next = LanternRun(
      now: now,
      campaign: true,
      autoAttack: old.autoAttack,
    );
    next._gold = old.gold;
    next._upgrades = old.upgrades;
    next._victories = old.victories;
    next._paused = old.paused;
    next._charge = old.charge;
    for (var i = 0; i < 3; i++) {
      next.sectorWins[i] = (old.victories - i * 5).clamp(0, 5);
    }
    next.encounter = next.litLanterns.clamp(0, 2);
    next._enemyHealth = next.maxHealth;
    return next;
  }
  final bool campaign;
  int _vitality = 0;
  int get vitality => _vitality;
  int get vitalityCost => 4 + vitality * 4;
  int healthFor(HeroSpec hero) => hero.health + (level - 1) * 4 + vitality * 5;
  bool get canBuyVitality =>
      campaign &&
      encounterState != 'active' &&
      vitality < 10 &&
      gold >= vitalityCost;
  bool buyVitality() {
    if (!canBuyVitality) return false;
    _gold -= vitalityCost;
    _vitality++;
    heroHealth = maxHeroHealth;
    return true;
  }

  final Map<String, int> _skillRanks = {};
  int mana = 6;
  int skillCooldownMs = 0;
  int skillRank(String id) => _skillRanks[id] ?? 0;
  int skillCost(SkillSpec skill) => skill.cost * (skillRank(skill.id) + 1);
  bool canBuySkill(SkillSpec skill) =>
      campaign &&
      encounterState != 'active' &&
      skillRank(skill.id) < 3 &&
      gold >= skillCost(skill);
  bool buySkill(String id) {
    final matches = skills.where((s) => s.id == id);
    if (matches.isEmpty || !canBuySkill(matches.first)) return false;
    _gold -= skillCost(matches.first);
    _skillRanks[id] = skillRank(id) + 1;
    return true;
  }

  bool canUseSkill(SkillSpec skill) =>
      campaign &&
      running &&
      skillRank(skill.id) > 0 &&
      mana >= skill.mana &&
      skillCooldownMs == 0 &&
      (skill.id != 'cura' || heroHealth < maxHeroHealth);
  bool useSkill(String id) {
    final matches = skills.where((s) => s.id == id);
    if (matches.isEmpty || !canUseSkill(matches.first)) return false;
    final rank = skillRank(id);
    mana -= matches.first.mana;
    skillCooldownMs = 1000;
    if (id == 'golpe') {
      _hit(damage + 3 * rank, flare: true);
    }
    if (id == 'cura') {
      heroHealth = (heroHealth + 6 * rank).clamp(0, maxHeroHealth);
    }
    if (id == 'hielo') {
      enemyRemainingMs = (enemyRemainingMs + 1000 * rank).clamp(1, 5000);
    }
    lastAction = id;
    return true;
  }

  String _heroId = 'farol';
  String get heroId => _heroId;
  HeroSpec get hero => heroes.firstWhere((h) => h.id == _heroId);
  bool selectHero(String id) {
    if (!campaign ||
        encounterState == 'active' ||
        !heroes.any((h) => h.id == id)) {
      return false;
    }
    _heroId = id;
    heroHealth = maxHeroHealth;
    _charge = 0;
    return true;
  }

  int encounter = 0;
  int battleRank = 0;
  int get nextRank => victories.clamp(0, 100);
  int nextEnemyHealth(int index) => enemies[index].health + nextRank * 2;
  int get enemyDamage => (enemy.damage / 2).ceil() + battleRank ~/ 8;
  bool selectEnemy(int index) {
    if (!campaign ||
        index < 0 ||
        index >= enemies.length ||
        !unlocked(index) ||
        encounterState == 'active') {
      return false;
    }
    encounter = index;
    encounterState = 'preparation';
    battleRank = nextRank;
    _enemyHealth = maxHealth;
    return true;
  }

  String encounterState = 'preparation';
  int heroHealth = 20;
  int protectionMs = 0;
  int protectCooldownMs = 0;
  int enemyRemainingMs = 3500;
  int xp = 0;
  bool bossDefeated = false;
  int flaresUsed = 0;
  final List<int> sectorWins = [0, 0, 0];
  final List<String> equipped = [];
  final List<int> claimed = [];
  bool sound = false,
      vibration = false,
      reducedMotion = false,
      assistance = false,
      tutorialSeen = false;
  int get level => (1 + xp ~/ 10).clamp(1, 5);
  int get maxHeroHealth => healthFor(hero);
  int get chargeTarget => equipped.contains('pabilo') ? 3 : 4;
  EnemySpec get enemy => enemies[encounter];
  bool get enemyIntent =>
      campaign && encounterState == 'active' && enemyRemainingMs <= 1000;
  bool get defeated => campaign && encounterState == 'defeated';
  bool get encounterWon => campaign && encounterState == 'won';
  bool get phaseTwo => encounter == 3 && _enemyHealth <= maxHealth ~/ 2;
  bool get armored => campaign && encounter == 1 && enemyRemainingMs > 1400;
  bool unlocked(int index) =>
      index == 0 || (index < 4 && sectorWins[index - 1] >= 5);
  bool beginEncounter(int index) {
    if (!campaign ||
        index < 0 ||
        index > 3 ||
        !unlocked(index) ||
        encounterState == 'active') {
      return false;
    }
    encounter = index;
    encounterState = 'active';
    heroHealth = maxHeroHealth;
    battleRank = nextRank;
    _enemyHealth = maxHealth;
    enemyRemainingMs = enemy.periodMs;
    protectionMs = 0;
    protectCooldownMs = 0;
    mana = 6;
    skillCooldownMs = 0;
    _resetTime();
    return true;
  }

  void returnToCamp() {
    encounterState = 'preparation';
    heroHealth = maxHeroHealth;
    mana = 6;
    protectionMs = 0;
    protectCooldownMs = 0;
    skillCooldownMs = 0;
    _resetTime();
  }

  bool retry() {
    if (!defeated) return false;
    return beginEncounter(encounter);
  }

  bool protect() {
    if (!running || protectCooldownMs > 0) return false;
    protectionMs = assistance ? 1800 : 1000;
    protectCooldownMs = 3000;
    return true;
  }

  bool equip(String id) {
    if (encounterState == 'active' ||
        !moduleNames.containsKey(id) ||
        !moduleUnlocked(id)) {
      return false;
    }
    if (equipped.remove(id)) return true;
    if (equipped.length == 2) return false;
    equipped.add(id);
    return true;
  }

  bool moduleUnlocked(String id) =>
      id == 'brasa' ||
      (id == 'cristal' && xp >= 5) ||
      (id == 'guarda' && sectorWins[0] >= 5) ||
      (id == 'pabilo' && level >= 3);
  bool questReady(int index) => index == 0
      ? _victories > 0
      : index == 1
      ? flaresUsed > 0
      : index == 2 && bossDefeated;
  bool claimQuest(int index) {
    if (index < 0 ||
        index > 2 ||
        claimed.contains(index) ||
        !questReady(index)) {
      return false;
    }
    claimed.add(index);
    _gold = (_gold + 6).clamp(0, 1000000);
    return true;
  }

  Map<String, Object?> toJson() => {
    'schemaVersion': 2,
    'heroId': _heroId,
    'vitality': vitality,
    'battleRank': battleRank,
    'skillRanks': Map<String, int>.from(_skillRanks),
    'mana': mana,
    'skillCooldownMs': skillCooldownMs,
    'contentVersion': 1,
    'gold': _gold,
    'victories': _victories,
    'upgrades': _upgrades,
    'enemyHealth': _enemyHealth,
    'charge': _charge,
    'paused': _paused,
    'autoAttack': _autoAttack,
    'campaign': campaign,
    'encounter': encounter,
    'encounterState': encounterState,
    'heroHealth': heroHealth,
    'protectionMs': protectionMs,
    'protectCooldownMs': protectCooldownMs,
    'enemyRemainingMs': enemyRemainingMs,
    'xp': xp,
    'bossDefeated': bossDefeated,
    'flaresUsed': flaresUsed,
    'sectorWins': sectorWins.toList(),
    'equipped': equipped.toList(),
    'claimed': claimed.toList(),
    'sound': sound,
    'vibration': vibration,
    'reducedMotion': reducedMotion,
    'assistance': assistance,
    'tutorialSeen': tutorialSeen,
  };

  factory LanternRun.fromJson(
    Map<String, Object?> json, {
    required Duration Function() now,
  }) {
    int integer(String key, int min, int max) {
      final value = json[key];
      if (value is! int || value < min || value > max) {
        throw FormatException('Campo inválido: $key');
      }
      return value;
    }

    if (![1, 2].contains(json['schemaVersion']) ||
        json['contentVersion'] != 1) {
      throw const FormatException('Versión de guardado no compatible');
    }
    if (json['paused'] is! bool || json['autoAttack'] is! bool) {
      throw const FormatException('Preferencias inválidas');
    }
    final run = LanternRun(
      now: now,
      autoAttack: json['autoAttack'] as bool,
      campaign: json['campaign'] == true,
    );
    if (json['schemaVersion'] == 2) {
      final id = json['heroId'];
      if (id is! String || !heroes.any((h) => h.id == id)) {
        throw const FormatException('Héroe inválido');
      }
      run._heroId = id;
    }
    run._gold = integer('gold', 0, 1000000);
    run._victories = integer('victories', 0, 1000000);
    run._upgrades = integer('upgrades', 0, 5);
    run._charge = integer('charge', 0, 4);
    if (json.containsKey('vitality')) {
      run._vitality = integer('vitality', 0, 10);
    }
    if (json.containsKey('battleRank')) {
      run.battleRank = integer('battleRank', 0, 100);
    }
    if (json.containsKey('skillRanks')) {
      final ranks = json['skillRanks'];
      if (ranks is! Map ||
          ranks.entries.any(
            (e) =>
                !skills.any((s) => s.id == e.key) ||
                e.value is! int ||
                (e.value as int) < 1 ||
                (e.value as int) > 3,
          )) {
        throw const FormatException('Habilidades inválidas');
      }
      run._skillRanks.addAll(Map<String, int>.from(ranks));
      run.mana = integer('mana', 0, 6);
      run.skillCooldownMs = integer('skillCooldownMs', 0, 1000);
    }
    if (run.campaign) {
      run.encounter = integer('encounter', 0, 3);
      final state = json['encounterState'];
      if (!['preparation', 'active', 'won', 'defeated'].contains(state)) {
        throw const FormatException('Encuentro inválido');
      }
      run.encounterState = state as String;
      run.xp = integer('xp', 0, 1000000);
      run.heroHealth = integer('heroHealth', 0, run.maxHeroHealth);
      run.protectionMs = integer('protectionMs', 0, 1800);
      run.protectCooldownMs = integer('protectCooldownMs', 0, 3000);
      run.enemyRemainingMs = integer('enemyRemainingMs', 1, 5000);
      run.flaresUsed = integer('flaresUsed', 0, 1000000);
      final wins = json['sectorWins'];
      if (wins is! List ||
          wins.length != 3 ||
          wins.any((v) => v is! int || v < 0 || v > 5)) {
        throw const FormatException('Ruta inválida');
      }
      run.sectorWins.setAll(0, wins.cast<int>());
      for (final field in ['equipped', 'claimed']) {
        final values = json[field];
        if (values is! List || values.toSet().length != values.length) {
          throw FormatException('Lista inválida: $field');
        }
      }
      final modules = (json['equipped'] as List);
      if (modules.length > 2 ||
          modules.any((v) => v is! String || !moduleNames.containsKey(v))) {
        throw const FormatException('Módulos inválidos');
      }
      run.equipped.addAll(modules.cast<String>());
      final claims = json['claimed'] as List;
      if (claims.any((v) => v is! int || v < 0 || v > 2)) {
        throw const FormatException('Encargos inválidos');
      }
      run.claimed.addAll(claims.cast<int>());
      for (final key in [
        'bossDefeated',
        'sound',
        'vibration',
        'reducedMotion',
        'assistance',
        'tutorialSeen',
      ]) {
        if (json[key] is! bool) {
          throw FormatException('Preferencia inválida: $key');
        }
      }
      run.bossDefeated = json['bossDefeated'] as bool;
      run.sound = json['sound'] as bool;
      run.vibration = json['vibration'] as bool;
      run.reducedMotion = json['reducedMotion'] as bool;
      run.assistance = json['assistance'] as bool;
      run.tutorialSeen = json['tutorialSeen'] as bool;
    }
    run._enemyHealth = integer(
      'enemyHealth',
      run.campaign && run.encounterState != 'active' ? 0 : 1,
      run.maxHealth,
    );
    run._paused = json['paused'] as bool;
    if (run.campaign) {
      if (run.encounterState == 'active' && run.heroHealth == 0) {
        throw const FormatException('Vida incompatible con combate activo');
      }
      if (run.equipped.any((id) => !run.moduleUnlocked(id))) {
        throw const FormatException('Módulo sin desbloquear');
      }
      if (!run.unlocked(run.encounter)) {
        throw const FormatException('Encuentro sin desbloquear');
      }
    }
    return run;
  }
  late Duration _last;
  Duration _remainder = Duration.zero;
  int _enemyHealth = 4;
  int _gold = 0;
  int _victories = 0;
  int _pulses = 0;
  int lastDamage = 0;
  String lastAction = 'attack';
  int enemyStrikes = 0;
  int lastIncomingDamage = 0;
  bool lastBlocked = false;
  int _upgrades = 0;
  bool _paused = false;
  bool _active = true;
  late bool _autoAttack;
  int _charge = 0;
  Duration? _lastAttack;
  bool get autoAttack => _autoAttack;
  int get charge => _charge;
  bool get canFlare => running && _charge >= chargeTarget;

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
    flaresUsed = (flaresUsed + 1).clamp(0, 1000000);
    _hit(damage * (equipped.contains('cristal') ? 4 : 3), flare: true);
    return true;
  }

  void _hit(int amount, {bool flare = false}) {
    _pulses++;
    if (armored && !flare) amount = (amount / 2).ceil();
    lastDamage = amount.clamp(0, _enemyHealth);
    lastAction = flare ? 'flare' : 'attack';
    _enemyHealth -= amount;
    if (_enemyHealth <= 0) {
      _gold = (_gold + 2).clamp(0, 1000000);
      _victories = (_victories + 1).clamp(0, 1000000);
      if (campaign) {
        _enemyHealth = 0;
        encounterState = 'won';
        xp = (xp + 2).clamp(0, 1000000);
        if (encounter < 3) {
          sectorWins[encounter] = (sectorWins[encounter] + 1).clamp(0, 5);
        }
        if (encounter == 3) bossDefeated = true;
      } else {
        _enemyHealth = maxHealth;
      }
    }
  }

  bool get paused => _paused;
  bool get running =>
      _active && !_paused && (!campaign || encounterState == 'active');

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
  int get damage =>
      (campaign ? hero.damage : 1) +
      _upgrades +
      (equipped.contains('brasa') ? 1 : 0);
  int get upgrades => _upgrades;
  int get upgradeCost => 6 + 4 * _upgrades;
  bool get canUpgrade => _upgrades < 5 && _gold >= upgradeCost;
  int get litLanterns => campaign
      ? sectorWins.where((v) => v == 5).length
      : (_victories ~/ 5).clamp(0, 3);
  int get stage => litLanterns.clamp(0, 2);
  bool get completed => litLanterns == 3;
  int get completionCount => completed ? 1 : 0;
  int get stageVictories => completed ? 5 : _victories % 5;
  int get maxHealth => campaign ? enemy.health + battleRank * 2 : 4 + stage * 2;

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
    if (!running || delta.isNegative) {
      _remainder = Duration.zero;
      return false;
    }
    // Nunca recuperar más de un segundo por muestreo tras un bloqueo.
    _remainder += delta > const Duration(seconds: 1)
        ? const Duration(seconds: 1)
        : delta;
    var changed = false;
    if (campaign) {
      final ms = delta.inMilliseconds.clamp(0, 1000);
      skillCooldownMs = (skillCooldownMs - ms).clamp(0, 1000);
      final previousProtection = protectionMs;
      final untilHit = enemyRemainingMs;
      protectionMs = (protectionMs - ms).clamp(0, 1800);
      protectCooldownMs = (protectCooldownMs - ms).clamp(0, 3000);
      enemyRemainingMs -= ms;
      if (enemyRemainingMs <= 0) {
        var hit = enemyDamage + (phaseTwo ? 2 : 0);
        enemyStrikes++;
        lastBlocked = previousProtection > 0 && previousProtection >= untilHit;
        if (previousProtection > 0 && previousProtection >= untilHit) {
          hit = equipped.contains('guarda') ? 0 : (hit * .25).ceil();
          protectionMs = 0;
        }
        lastIncomingDamage = hit.clamp(0, heroHealth);
        heroHealth = (heroHealth - hit).clamp(0, maxHeroHealth);
        enemyRemainingMs += phaseTwo ? 2500 : enemy.periodMs;
        if (heroHealth == 0) encounterState = 'defeated';
      }
      changed = ms > 0;
    }
    if (!_autoAttack) {
      _remainder = Duration.zero;
      return changed;
    }
    while (_remainder >= const Duration(seconds: 1)) {
      _remainder -= const Duration(seconds: 1);
      if (running) _hit(damage);
      changed = true;
    }
    return changed;
  }
}
