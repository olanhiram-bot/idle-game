import 'dart:convert';

import 'package:sembast/sembast.dart';

import '../domain/lantern_run.dart';

class SaveRepository {
  SaveRepository(this.db, {required this.owner, int Function()? nowMs})
    : nowMs = nowMs ?? (() => DateTime.now().millisecondsSinceEpoch);
  final Database db;
  final String owner;
  final int Function() nowMs;
  final store = StoreRef<String, Object?>.main();
  int _generation = -1;
  int _revision = 0;
  Future<void> _tail = Future.value();

  Map<String, Object?> validate(Object? value) {
    if (value is! Map) throw const FormatException('Guardado ilegible');
    final map = Map<String, Object?>.from(value);
    LanternRun.fromJson(map, now: () => Duration.zero);
    return map;
  }

  String exportJson(Map<String, Object?> snapshot) =>
      jsonEncode(validate(snapshot));
  Future<void> importJson(String text) async {
    if (utf8.encode(text).length > 1048576) {
      throw const FormatException('Máximo 1 MiB');
    }
    await save(validate(jsonDecode(text)));
  }

  Future<String> quarantineJson() async =>
      jsonEncode(await store.record('quarantine').get(db));

  Future<bool> acquire() => db.transaction((txn) async {
    final lease = await store.record('lease').get(txn);
    final old = lease is Map ? lease : <String, Object?>{};
    final now = nowMs();
    final until = (old['until'] as int?) ?? 0;
    if (old['owner'] != owner && until > now && until - now <= 30000) {
      return false;
    }
    _generation = ((old['generation'] as int?) ?? 0) + 1;
    _revision = (await store.record('revision').get(txn) as int?) ?? 0;
    await store.record('lease').put(txn, {
      'owner': owner,
      'generation': _generation,
      'until': now + 30000,
    });
    return true;
  });

  Future<void> _guard(Transaction txn) async {
    final raw = await store.record('lease').get(txn);
    if (raw is! Map ||
        raw['owner'] != owner ||
        raw['generation'] != _generation ||
        (raw['until'] as int) <= nowMs()) {
      throw StateError(
        'La partida está abierta en otra pestaña. Recarga para continuar.',
      );
    }
    final revision = (await store.record('revision').get(txn) as int?) ?? 0;
    if (revision != _revision) {
      throw StateError('La partida ha cambiado. Recarga antes de guardar.');
    }
  }

  Future<void> renew() {
    final work = _tail
        .catchError((Object _) {})
        .then(
          (_) => db.transaction((txn) async {
            await _guard(txn);
            await store.record('lease').put(txn, {
              'owner': owner,
              'generation': _generation,
              'until': nowMs() + 30000,
            });
          }),
        );
    _tail = work;
    return work;
  }

  Future<Map<String, Object?>?> load() async {
    final raw = await store.record('current').get(db);
    return raw == null ? null : validate(raw);
  }

  Future<void> save(Map<String, Object?> snapshot) {
    final copy = validate(jsonDecode(jsonEncode(snapshot)));
    final generation = _generation;
    final work = _tail.catchError((Object _) {}).then((_) async {
      if (generation != _generation) throw StateError('Escritura obsoleta');
      final revision = await db.transaction((txn) async {
        await _guard(txn);
        final current = await store.record('current').get(txn);
        if (current != null) {
          validate(current);
          await store.record('backup').put(txn, current);
        }
        await store.record('current').put(txn, copy);
        final next = _revision + 1;
        await store.record('revision').put(txn, next);
        return next;
      });
      _revision = revision;
    });
    _tail = work;
    return work;
  }

  Future<void> restoreBackup() async {
    final revision = await db.transaction((txn) async {
      await _guard(txn);
      final backup = validate(await store.record('backup').get(txn));
      final current = await store.record('current').get(txn);
      if (current != null) await store.record('quarantine').put(txn, current);
      await store.record('current').put(txn, backup);
      await store.record('revision').put(txn, _revision + 1);
      return _revision + 1;
    });
    _revision = revision;
  }

  Future<void> close() async {
    await _tail.catchError((Object _) {});
    await db.transaction((txn) async {
      final lease = await store.record('lease').get(txn);
      if (lease is Map &&
          lease['owner'] == owner &&
          lease['generation'] == _generation) {
        await store.record('lease').put(txn, {
          'owner': owner,
          'generation': _generation,
          'until': 0,
        });
      }
    });
    await db.close();
  }
}
