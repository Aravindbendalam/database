import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('repos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE repositories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        node_id TEXT NOT NULL,
        name TEXT NOT NULL,
        avatar_url TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertRepo(Map<String, dynamic> repo) async {
    final db = await database;
    await db.insert('repositories', repo);
  }

  Future<List<Map<String, dynamic>>> fetchRepos() async {
    final db = await database;
    return await db.query('repositories');
  }
}
