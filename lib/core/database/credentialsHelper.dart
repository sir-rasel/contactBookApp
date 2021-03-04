import 'dart:async';
import 'package:contact_book/core/database/databaseInitializer.dart';
import 'package:contact_book/core/models/credentials.dart';
import 'package:contact_book/core/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CredentialsDBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String EMAIL = 'email';
  static const String PASSWORD = 'password';
  static const String TABLE = 'UserCredentials';
  static const String DB_NAME = 'contactBook.db';

  Future<Database> get db async {
    if (_db == null) {
      DatabaseInitializer();
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    final documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory, DB_NAME);

    var db = await openDatabase(path, version: 1, onOpen: _onOpen);
    return db;
  }

  _onOpen(Database db) async {
    await db
        .execute('CREATE TABLE IF NOT EXISTS $TABLE('
        '$ID INTEGER PRIMARY KEY,'
        '$EMAIL TEXT,'
        '$PASSWORD TEXT)');
  }

  Future<LoginCredentials> save(LoginCredentials user) async {
    var dbClient = await db;
    user.id = await dbClient.insert(TABLE, user.toMap());
    return user;
  }

  Future<LoginCredentials> getUser(String email) async {
    var dbContact = await db;
    List<Map> maps = await dbContact.query(TABLE,
        columns: [PASSWORD],
        where: '$EMAIL = ?',
        whereArgs: [email]);
    if (maps.isNotEmpty) {
      return LoginCredentials.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(LoginCredentials user) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, user.toMap(),
        where: '$ID = ?', whereArgs: [user.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}