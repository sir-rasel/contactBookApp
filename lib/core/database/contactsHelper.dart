import 'dart:async';
import 'package:contact_book/core/models/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ContactDBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String EMAIL = 'email';
  static const String CONTACT_EMAIL = 'ContactEmail';
  static const String PHONE = 'phone';
  static const String ADDRESS = 'address';
  static const String TABLE = 'Contacts';
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

    var db = await openDatabase(path, version: 1, onOpen: _onOpen);
    return db;
  }

  _onOpen(Database db) async {
    await db
        .execute('CREATE TABLE IF NOT EXISTS $TABLE('
        '$ID INTEGER PRIMARY KEY,'
        '$NAME TEXT,'
        '$EMAIL TEXT,'
        '$CONTACT_EMAIL TEXT,'
        '$PHONE TEXT,'
        '$ADDRESS TEXT)');
  }

  Future<Contact> save(Contact contact) async {
    var dbClient = await db;
    contact.id = await dbClient.insert(TABLE, contact.toMap());
    print('$contact.id');
    return contact;
  }

  Future<List<Contact>> getContacts(String email) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(
        TABLE, columns: [
      ID, NAME, EMAIL, CONTACT_EMAIL,
      PHONE, ADDRESS], where: '$EMAIL = ?',
        whereArgs: [email]);

    List<Contact> contacts = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        contacts.add(Contact.fromMap(maps[i]));
      }
    }
    return contacts;
  }

  Future<bool> isContactExist(String phone) async {
    var dbContact = await db;
    List<Map> maps = await dbContact.query(TABLE,
        columns: [NAME],
        where: '$PHONE = ?',
        whereArgs: [phone]);

    if (maps.isNotEmpty) {
      print(maps.toString());
      return false;
    } else {
      return true;
    }
  }

  Future<Contact> getContact(int id) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(
        TABLE, columns: [
      ID, NAME, EMAIL, CONTACT_EMAIL,
      PHONE, ADDRESS], where: '$ID = ?',
        whereArgs: [id]);

    Contact contact;
    if (maps.length > 0) {
      contact = Contact.fromMap(maps[0]);
    }
    return contact;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(Contact contact) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, contact.toMap(),
        where: '$ID = ?', whereArgs: [contact.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}