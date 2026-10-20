import 'package:sembast_web/sembast_web.dart';

Future<Database> openSaveDatabase() =>
    databaseFactoryWeb.openDatabase('farol-de-ceniza');
