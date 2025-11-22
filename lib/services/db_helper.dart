import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/contact.dart';

class DBHelper {
  DBHelper._();
  static final DBHelper instance = DBHelper._();
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "contacts.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("""
          CREATE TABLE contacts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            phone TEXT NOT NULL
          );
        """);
      },
    );
  }

  Future<List<Contact>> getContacts() async {
    final db = await database;
    final res = await db.query("contacts", orderBy: "id DESC");
    return res.map((e) => Contact.fromMap(e)).toList();
  }

  Future<int> insertContact(Contact c) async {
    final db = await database;
    return await db.insert("contacts", c.toMap());
  }

  Future<int> updateContact(Contact c) async {
    final db = await database;
    return await db.update(
      "contacts",
      c.toMap(),
      where: "id = ?",
      whereArgs: [c.id],
    );
  }

  Future<int> deleteContact(int id) async {
    final db = await database;
    return await db.delete(
      "contacts",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
