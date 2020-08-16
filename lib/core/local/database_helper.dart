import 'package:base/data/models/podcast.dart';
import 'package:base/data/models/radio_station.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final String _databaseName = 'radios.db';
  static final int _databaseVersion = 1;
  static DatabaseHelper _databaseHelper = DatabaseHelper._internal();
  static Database _database;

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    return _databaseHelper;
  }

  DatabaseHelper._internal() {
    _databaseHelper = DatabaseHelper._createInstance();
  }

  Future<Database> get database async {
    if (_database == null) _database = await initializeDatabase();

    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}/$_databaseName';

    return openDatabase(path, version: _databaseVersion, onCreate: _createDb);
  }

  static void deleteDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}/$_databaseName';

    deleteDatabase(path);
  }

  static void _createDb(Database db, int version) async {
    await db.execute(Podcast.createTable);
    await db.execute(RadioStation.createTable);
  }

  static void emptyAllTables() {
    _databaseHelper.clearTableContent(Podcast.table);
    _databaseHelper.clearTableContent(RadioStation.table);
  }

  Future<int> clearTableContent(String table) async {
    Database db = await this.database;
    var result = await db.rawDelete('DELETE FROM $table');

    return result;
  }

  Future<List<dynamic>> getList(String table, {String where, int limit, String orderBy}) async {
    Database db = await this.database;
    var result = await db.query(table, where: where, limit: limit, orderBy: orderBy);
    return result;
  }

  Future<int> insert(String table, dynamic model) async {
    Database db = await this.database;
    var result = await db.insert(table, model.toDatabaseJson());
    return result;
  }

  Future<int> bulkInsert(String table, list) async {
    Database db = await this.database;
    Batch batch = db.batch();
    for (var i = 0; i < list.length; i++) {
      var item = list[i];
      batch.insert(table, item.toJson());
    }

    await batch.commit(noResult: true);
    return 1;
  }

  Future<int> update(String table, dynamic model) async {
    Database db = await this.database;
    var result = await db.update(table, model.toJson(), where: 'id = ?', whereArgs: [model.id]);

    return result;
  }

  Future<int> delete(String table, int id) async {
    Database db = await this.database;
    var result = await db.rawDelete('DELETE FROM $table WHERE id = $id');

    return result;
  }

  Future<int> getCount(String table) async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT(*) from $table');
    return Sqflite.firstIntValue(x);
  }

  Future<dynamic> find(String table, id) async {
    Database db = await this.database;
    List<Map<String, dynamic>> maps = await db.query(table, where: "id = ?", whereArgs: [id]);
    return (maps.length > 0) ? maps.first : null;
  }

  Future<bool> exist(String table, id) async {
    Database db = await this.database;
    List<Map<String, dynamic>> maps = await db.query(table, where: "id = ?", whereArgs: [id]);
    return maps.length > 0;
  }
}
