import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/restaurant.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tableFavorites = 'favorites';
  static const String _tableReviews = 'my_reviews';

Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      join(path, 'restaurant_db.db'),
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tableFavorites (
            id TEXT PRIMARY KEY, name TEXT, description TEXT,
            pictureId TEXT, city TEXT, rating REAL
          )'''
        );
        await db.execute('''CREATE TABLE $_tableReviews (
            restaurantId TEXT PRIMARY KEY, name TEXT, review TEXT, date TEXT
          )'''
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''CREATE TABLE $_tableReviews (
            restaurantId TEXT PRIMARY KEY, name TEXT, review TEXT, date TEXT
          )''');
        }
      },
    );
    return db;
  }

  Future<Database> get database async {
    _database ??= await _initializeDb();
    return _database!;
  }

  Future<void> insertFavorite(Restaurant restaurant) async {
    final db = await database;
    await db.insert(_tableFavorites, {
      'id': restaurant.id, 'name': restaurant.name, 'description': restaurant.description,
      'pictureId': restaurant.pictureId, 'city': restaurant.city, 'rating': restaurant.rating,
    });
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;
    await db.delete(_tableFavorites, where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getFavoriteById(String id) async {
    final db = await database;
    final results = await db.query(_tableFavorites, where: 'id = ?', whereArgs: [id]);
    return results.isNotEmpty ? results.first : null;
  }

  Future<List<Restaurant>> getFavorites() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(_tableFavorites);
    return results.map((res) => Restaurant.fromJson(res)).toList();
  }

  Future<void> insertOrUpdateReview(String restaurantId, String name, String review, String date) async {
    final db = await database;
    await db.insert(
      _tableReviews,
      {'restaurantId': restaurantId, 'name': name, 'review': review, 'date': date},
      conflictAlgorithm: ConflictAlgorithm.replace, 
    );
  }

  Future<void> deleteReview(String restaurantId) async {
    final db = await database;
    await db.delete(_tableReviews, where: 'restaurantId = ?', whereArgs: [restaurantId]);
  }

  Future<Map<String, dynamic>?> getMyReview(String restaurantId) async {
    final db = await database;
    final results = await db.query(_tableReviews, where: 'restaurantId = ?', whereArgs: [restaurantId]);
    return results.isNotEmpty ? results.first : null;
  }
}