import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class RestaurantHelper {
  static final _databaseName = 'restaurant_database.db';
  static final _databaseVersion = 1;

  static final table = 'restaurants';
  static final columnId = 'id';
  static final columnName = 'name';
  static final columnImageUrl = 'imageUrl';
  static final columnAddress = 'address';
  static final columnRating = 'rating';

  // seeders when the databse is first created
  static final List<Map<String, dynamic>> initialRestaurants = [
    {
      'name': 'Restaurant 1',
      'address': '123 Main St',
      'rating': 4,
      'imageUrl': 'assets/images/restaurant0.jpg',
    },
    {
      'name': 'Restaurant 2',
      'address': '456 Oak St',
      'rating': 3,
      'imageUrl': 'assets/images/restaurant1.jpg',
    },
    {
      'name': 'Restaurant 3',
      'address': '789 Elm St',
      'rating': 5,
      'imageUrl': 'assets/images/restaurant2.jpg',
    }, {
      'name': 'Restaurant 3',
      'address': '789 Elm St',
      'rating': 5,
      'imageUrl': 'assets/images/restaurant2.jpg',
    }, {
      'name': 'Restaurant 3',
      'address': '789 Elm St',
      'rating': 5,
      'imageUrl': 'assets/images/restaurant2.jpg',
    },
  ];

  static Database? _database;
  static final RestaurantHelper instance =
      RestaurantHelper._privateConstructor();

  RestaurantHelper._privateConstructor();

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
        $columnName TEXT NOT NULL,
        $columnImageUrl TEXT NOT NULL,
        $columnAddress TEXT NOT NULL,
        $columnRating INTEGER
      )
      ''');
    for (var restaurant in initialRestaurants) {
      await db.insert(table, restaurant);
    }
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
