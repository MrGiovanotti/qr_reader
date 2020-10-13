import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_reader/src/models/scan.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static DatabaseProvider _databaseProvider;
  static Database _database;
  static const String _TABLE_NAME = 'scans';

  static DatabaseProvider getInstance() {
    if (_databaseProvider == null) {
      _databaseProvider = DatabaseProvider._();
    }
    return _databaseProvider;
  }

  // Private constructor for singleton
  DatabaseProvider._();

  Future<Database> get getDatabase async {
    if (_database == null) {
      print("**** Creando base de datos ****");
      await createDatabase();
    }
    return _database;
  }

  createDatabase() async {
    Directory databaseDirectory = await getApplicationDocumentsDirectory();
    final String databasePath = join(databaseDirectory.path, "qr_reader.db");
    await deleteDatabase(databasePath);
    _database = await openDatabase(databasePath, version: 1,
        onCreate: (db, version) async {
      await db.execute("CREATE TABLE $_TABLE_NAME ("
          "id INTEGER PRIMARY KEY,"
          " value TEXT"
          ")");
    });
  }

  save(Scan scan) async {
    final db = await getDatabase;
    return await db.insert(_TABLE_NAME, scan.toJson());
  }

  Future<Scan> findById(int id) async {
    final db = await getDatabase;
    final result =
        await db.query(_TABLE_NAME, where: "id = ?", whereArgs: [id]);
    return result.isNotEmpty ? Scan.fromJson(result.first) : null;
  }

  Future<List<Scan>> findAll() async {
    final db = await getDatabase;
    final result = await db.query(_TABLE_NAME);
    return result.isNotEmpty
        ? result.map((e) => Scan.fromJson(e)).toList()
        : [];
  }

  Future<int> update(Scan scan) async {
    final db = await getDatabase;
    return await db.update(_TABLE_NAME, scan.toJson(),
        where: "id = ?", whereArgs: [scan.id]);
  }

  Future<int> delete(int id) async {
    final db = await getDatabase;
    return db.delete(_TABLE_NAME, where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    final db = await getDatabase;
    return db.delete(_TABLE_NAME);
  }
}
