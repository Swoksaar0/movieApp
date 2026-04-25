import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/movie_models.dart';

class LocalDbService {
  static final LocalDbService _instance = LocalDbService._internal();
  static Database? _database;

  LocalDbService._internal();

  factory LocalDbService() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'movie_hub.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE watchlist(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, genre TEXT)',
        );
      },
    );
  }

  Future<void> insertMovie(LocalMovie movie) async {
    final db = await database;
    await db.insert(
      'watchlist',
      movie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<LocalMovie>> getWatchlist() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('watchlist');
    return List.generate(maps.length, (i) => LocalMovie.fromMap(maps[i]));
  }

  Future<void> deleteMovie(int id) async {
    final db = await database;
    await db.delete(
      'watchlist',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}