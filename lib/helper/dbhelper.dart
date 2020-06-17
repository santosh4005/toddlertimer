import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'toddlerstuff.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE toddlertimes(id TEXT PRIMARY KEY, date TEXT, type TEXT)');
    }, version: 1);
  }

  static Future<void> insert(Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      "toddlertimes",
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> delete(String id) async {
    final db = await DBHelper.database();
    db.delete("toddlertimes", where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await DBHelper.database();
    return db.rawQuery("select * from toddlertimes order by date DESC");
  }

  static Future<void> deleteDB() async {
    final dbPath = await sql.getDatabasesPath();
    await sql.deleteDatabase(path.join(dbPath, 'toddlerstuff.db'));
  }
}
