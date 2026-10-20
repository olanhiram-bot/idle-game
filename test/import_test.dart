import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:idle_game/data/save_repository.dart';
import 'package:idle_game/domain/lantern_run.dart';

void main() {
  test(
    'Importación usa el mismo contrato de datos y respaldo recuperable',
    () async {
      final db = await databaseFactoryMemory.openDatabase('import');
      final repo = SaveRepository(db, owner: 'a');
      await repo.acquire();
      final original = LanternRun(now: () => Duration.zero).toJson();
      await repo.save(original);
      await expectLater(
        repo.importJson('{"schemaVersion":999}'),
        throwsFormatException,
      );
      expect(await repo.load(), original);
      await repo.importJson(repo.exportJson({...original, 'gold': 12}));
      expect((await repo.load())!['gold'], 12);
      await repo.restoreBackup();
      expect(await repo.load(), original);
      expect(await repo.quarantineJson(), contains('12'));
      await repo.close();
    },
  );
}
