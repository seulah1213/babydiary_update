import 'dart:io';

import 'package:babydiary_seulahpark/models/food_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class FoodDBhelper {
  static final FoodDBhelper instance = FoodDBhelper._instance();
  static Database _db;

  FoodDBhelper._instance();

  int id;
  String name;
  DateTime fromDate;
  DateTime toDate;
  int background;
  String step;
  int eventCount;

  String foodTable = 'food_table';
  String colId = 'id';
  String colName = 'name';
  String colFromDate = 'fromDate';
  String colToDate = 'toDate';
  String colBackground = 'background';
  String colStep = 'step';
  String colEventCount = 'eventCount';

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDB();
    }
    return _db;
  }

  Future<Database> _initDB() async {
    String databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, 'food_list.db');
    final foodListDB =
        await openDatabase(path, version: 1, onCreate: _createDB);
    return foodListDB;
  }

  void _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $foodTable(
      $colId INTEGER PRIMARY KEY AUTOINCREMENT,
      $colName TEXT,
      $colFromDate TEXT,
      $colToDate TEXT,
      $colBackground INTEGER,
      $colStep TEXT,
      $colEventCount INTEGER
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> getFoodMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(foodTable);
    return result;
  }

  Future<List<Food>> getFoodList() async {
    final List<Map<String, dynamic>> foodMapList = await getFoodMapList();
    final List<Food> foodList = [];
    foodMapList.forEach((foodMap) {
      foodList.add(Food.fromMap(foodMap));
    });
    return foodList;
  }

  Future<int> insertFood(Food food) async {
    Database db = await this.db;
    final int result = await db.insert(foodTable, food.toMap());
    return result;
  }

  Future<int> updateFood(Food food) async {
    Database db = await this.db;
    final int result = await db.update(
      foodTable,
      food.toMap(),
      where: '$colId = ?',
      whereArgs: [food.id],
    );
    return result;
  }

  Future<int> deleteFood(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      foodTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result;
  }
}
