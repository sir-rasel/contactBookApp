import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseInitializer {
  static Database _db;
  static const String DB_NAME = 'contactBook.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    final documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory, DB_NAME);

    // await deleteDatabase(path);

    var db = await openDatabase(path, version: 1, onCreate: null);
    return db;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}