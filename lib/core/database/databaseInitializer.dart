import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseInitializer {
  static Database _db;
  static const String DB_NAME = 'contactBook.db';
  static const String USER_TABLE = 'User';
  static const String CREDENTIALS_TABLE = 'UserCredentials';
  static const String CONTACT_TABLE = 'Contacts';
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String EMAIL = 'email';
  static const String PHONE = 'phone';
  static const String ADDRESS = 'address';
  static const String PASSWORD = 'password';

  Future<Database> get db async {
    if (_db != null) {
      print('Exist');
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    final documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory, DB_NAME);

    // await deleteDatabase(path);
    // print('database deleted');

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db
        .execute('CREATE TABLE IF NOT EXISTS $USER_TABLE('
        '$ID INTEGER PRIMARY KEY,'
        '$NAME TEXT,'
        '$EMAIL TEXT,'
        '$PHONE TEXT,'
        '$ADDRESS TEXT)');

    await db
        .execute('CREATE TABLE IF NOT EXISTS $CREDENTIALS_TABLE('
        '$ID INTEGER PRIMARY KEY,'
        '$EMAIL TEXT,'
        '$PASSWORD TEXT)');

    await db
        .execute('CREATE TABLE IF NOT EXISTS $CONTACT_TABLE('
        '$ID INTEGER PRIMARY KEY,'
        '$NAME TEXT,'
        '$EMAIL TEXT,'
        '$PHONE TEXT,'
        '$ADDRESS TEXT)');
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}