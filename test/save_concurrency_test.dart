import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:idle_game/data/save_repository.dart';
import 'package:idle_game/domain/lantern_run.dart';

void main() {
  test(
    'Escrituras y heartbeat serializados no crean falso conflicto de revisión',
    () async {
      final db = await databaseFactoryMemory.openDatabase(
        'concurrent-heartbeat',
      );
      final repo = SaveRepository(db, owner: 'test');
      await repo.acquire();
      final state = LanternRun(now: () => Duration.zero).toJson();
      await Future.wait([
        repo.save(state),
        repo.renew(),
        repo.save({...state, 'gold': 2}),
        repo.renew(),
      ]);
      expect((await repo.load())!['gold'], 2);
      await repo.close();
    },
  );
}
