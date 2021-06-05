import 'dart:io';

import 'package:babydiary_seulahpark/models/cube_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DBhelper {
  static final DBhelper instance = DBhelper._instance();
  static Database _db;

  DBhelper._instance();

  String cubeTable = 'cube_table';
  String colId = 'id';
  String colTitle = 'title';
  String colCount = 'cubecount';
  String colStartDate = 'startDate';
  String colEndDate = 'endDate';

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDB();
    }
    return _db;
  }

  Future<Database> _initDB() async {
    String databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, 'cube_list.db');
    final cubeListDB =
        await openDatabase(path, version: 1, onCreate: _createDB);
    return cubeListDB;
  }

  void _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $cubeTable(
      $colId INTEGER PRIMARY KEY AUTOINCREMENT,
      $colTitle TEXT,
      $colCount INTEGER,
      $colStartDate TEXT,
      $colEndDate TEXT
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> getCubeMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(cubeTable);
    return result;
  }

  Future<List<Cube>> getCubeList() async {
    final List<Map<String, dynamic>> cubeMapList = await getCubeMapList();
    final List<Cube> cubeList = [];
    cubeMapList.forEach((cubeMap) {
      cubeList.add(Cube.fromMap(cubeMap));
    });
    cubeList.sort((cubeA, cubeB) => cubeA.endDate.compareTo(cubeB.endDate));
    return cubeList;
  }

  Future<int> insertCube(Cube cube) async {
    Database db = await this.db;
    final int result = await db.insert(cubeTable, cube.toMap());
    return result;
  }

  Future<int> updateCube(Cube cube) async {
    Database db = await this.db;
    final int result = await db.update(
      cubeTable,
      cube.toMap(),
      where: '$colId = ?',
      whereArgs: [cube.id],
    );
    return result;
  }

  Future<int> deleteCube(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      cubeTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result;
  }
}
