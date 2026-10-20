import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:idle_game/data/save_repository.dart';
import 'package:idle_game/domain/lantern_run.dart';

void main() {
  test(
    'Propietario exclusivo, revisión, backup y rechazo de escritor antiguo',
    () async {
      var now = 1000;
      final db = await databaseFactoryMemory.openDatabase('lease');
      final a = SaveRepository(db, owner: 'a', nowMs: () => now);
      final b = SaveRepository(db, owner: 'b', nowMs: () => now);
      expect(await a.acquire(), isTrue);
      expect(await b.acquire(), isFalse);
      final state = LanternRun(now: () => Duration.zero).toJson();
      await a.save(state);
      await a.save({...state, 'gold': 2});
      expect((await a.load())!['gold'], 2);
      now += 31000;
      expect(await b.acquire(), isTrue);
      expect((await b.load())!['gold'], 2);
      await expectLater(a.save(state), throwsStateError);
      await b.save({...state, 'gold': 4});
      expect((await b.load())!['gold'], 4);
      await b.close();
    },
  );
  test(
    'Corrupción bloquea escrituras y permite restaurar copia válida',
    () async {
      final db = await databaseFactoryMemory.openDatabase('corrupt');
      final repo = SaveRepository(db, owner: 'a');
      await repo.acquire();
      final state = LanternRun(now: () => Duration.zero).toJson();
      await repo.save(state);
      await repo.save({...state, 'gold': 2});
      await StoreRef<String, Object?>.main().record('current').put(db, {
        'broken': true,
      });
      await expectLater(repo.load(), throwsFormatException);
      await expectLater(repo.save(state), throwsFormatException);
      await repo.restoreBackup();
      expect((await repo.load())!['gold'], 0);
      expect(
        await StoreRef<String, Object?>.main().record('quarantine').get(db),
        isNotNull,
      );
      await repo.close();
    },
  );
}
