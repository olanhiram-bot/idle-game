import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';

Future<Database> openSaveDatabase() async {
  final dir = await getApplicationSupportDirectory();
  await dir.create(recursive: true);
  return databaseFactoryIo.openDatabase('${dir.path}/farol.db');
}
