import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/food.dart';
import '../models/order.dart';
import 'food_helper.dart';

class CartHelper {
  static final _databaseName = 'cart_database.db';
  static final _databaseVersion = 1;

  static final table = 'orders';
  static final columnId = 'id';
  static final columnFoodId = 'foodId';
  static final columnDate = 'date';
  static final columnQuantity = 'quantity';

  static Database? _database;
  static final CartHelper instance = CartHelper._privateConstructor();

  CartHelper._privateConstructor();

  static Future<CartHelper> create() async {
    CartHelper helper = CartHelper._privateConstructor();
    await helper._initDatabase();
    return helper;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnFoodId INTEGER NOT NULL,
        $columnDate TEXT NOT NULL,
        $columnQuantity INTEGER NOT NULL
      )
      ''');
  }

  Future<int> insert(Order order) async {
    Database db = await instance.database;
    return await db.insert(table, order.toMap());
  }

  Future<List<Order>> queryAllRows() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(table);
    List<Order> orders = [];
    for (Map<String, dynamic> map in maps) {
      int foodId = map[columnFoodId];
      Food? food = await FoodHelper.instance.getFood(foodId);
      orders.add(Order.fromMap(map, food!));
    }
    return orders;
  }



  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
  Future<void> deleteAll() async {
    Database db = await instance.database;
    await db.delete(table);
  }

}
