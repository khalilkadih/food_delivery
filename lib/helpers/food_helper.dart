import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/food.dart';

class FoodHelper {
  static final _databaseName = 'food_database.db';
  static final _databaseVersion = 1;

  static final table = 'foods';
  static final columnId = 'id';
  static final columnRestaurantId = 'restaurant_id';
  static final columnImageUrl = 'imageUrl';
  static final columnName = 'name';
  static final columnPrice = 'price';

  static final List<Map<String, dynamic>> initialFoods = [
    {
      'restaurant_id': 1,
      'name': 'Pizza',
      'price': 10.99,
      'imageUrl': 'assets/images/pizza.jpg',
    },
    {
      'restaurant_id': 1,
      'name': 'Ramen',
      'price': 9.99,
      'imageUrl': 'assets/images/ramen.jpg',
    },
    {
      'restaurant_id': 2,
      'name': 'Burger',
      'price': 8.49,
      'imageUrl': 'assets/images/burger.jpg',
    },
    {
      'restaurant_id': 2,
      'name': 'Pasta',
      'price': 9.49,
      'imageUrl': 'assets/images/pasta.jpg',
    },
    {
      'restaurant_id': 3,
      'name': 'Salmon',
      'price': 7.99,
      'imageUrl': 'assets/images/salmon.jpg',
    },
    {
      'restaurant_id': 3,
      'name': 'Steak',
      'price': 8.49,
      'imageUrl': 'assets/images/steak.jpg',

    }, {
      'restaurant_id': 3,
      'name': 'Steak',
      'price': 8.49,
      'imageUrl': 'assets/images/steak.jpg',

    }, {
      'restaurant_id': 3,
      'name': 'Steak',
      'price': 8.49,
      'imageUrl': 'assets/images/steak.jpg',

    }, {
      'restaurant_id': 3,
      'name': 'Steak',
      'price': 8.49,
      'imageUrl': 'assets/images/steak.jpg',

    }, {
      'restaurant_id': 2,
      'name': 'Steak',
      'price': 8.49,
      'imageUrl': 'assets/images/steak.jpg',

    }, {
      'restaurant_id': 2,
      'name': 'Steak',
      'price': 8.49,
      'imageUrl': 'assets/images/steak.jpg',

    },
  ];

  static Database? _database;
  static final FoodHelper instance = FoodHelper._privateConstructor();

  FoodHelper._privateConstructor();

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
        $columnRestaurantId INTEGER NOT NULL,
        $columnName TEXT NOT NULL,
        $columnImageUrl TEXT NOT NULL,
        $columnPrice REAL NOT NULL
      )
      ''');
    for (var food in initialFoods) {
      await db.insert(table, food);
    }
  }

  Future<int> insert(Food food) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {
      columnRestaurantId: food.restaurantId,
      columnName: food.name,
      columnPrice: food.price,
      columnImageUrl: food.imageUrl,
    };
    return await db.insert(table, row);
  }

  Future<List<Food>> queryFoodsByRestaurantId(int restaurantId) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table,
        where: '$columnRestaurantId = ?', whereArgs: [restaurantId]);
    return List.generate(maps.length, (i) {
      return Food(
        id: maps[i][columnId],
        name: maps[i][columnName],
        price: maps[i][columnPrice],
        restaurantId: maps[i][columnRestaurantId],
        imageUrl: maps[i][columnImageUrl],
      );
    });
  }

  Future<List<Food>> getAllFoods() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('foods');
    return List.generate(maps.length, (i) {
      return Food.fromMap(maps[i]);
    });
  }

  Future<Food?> getFood(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return Food.fromMap(maps.first);
    }
    return null;
  }
}
