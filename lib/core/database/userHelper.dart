import 'dart:async';
import 'package:contact_book/core/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'databaseInitializer.dart';

class UserDBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String EMAIL = 'email';
  static const String PHONE = 'phone';
  static const String ADDRESS = 'address';
  static const String TABLE = 'User';
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
        '$NAME TEXT,'
        '$EMAIL TEXT,'
        '$PHONE TEXT,'
        '$ADDRESS TEXT)');
  }

  Future<User> save(User user) async {
    var dbClient = await db;
    user.id = await dbClient.insert(TABLE, user.toMap());
    return user;
  }

  Future<List<User>> getUsers() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(
        TABLE, columns: [
          ID, NAME, EMAIL,
          PHONE, ADDRESS
        ]);
    List<User> users = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        users.add(User.fromMap(maps[i]));
      }
    }
    return users;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(User user) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, user.toMap(),
        where: '$ID = ?', whereArgs: [user.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}