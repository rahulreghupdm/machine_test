import 'package:sample_machine_test/model/post_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('posts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE posts (
        id INTEGER PRIMARY KEY,
        userId INTEGER,
        title TEXT,
        body TEXT
      )
    ''');
  }

  // Insert Post into database
  Future<void> insertPost(Post post) async {
    final db = await database;
    await db.insert('posts', post.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Retrieve all posts
  Future<List<Post>> fetchPosts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('posts');

    return List.generate(maps.length, (i) {
      return Post.fromJson(maps[i]);
    });
  }

  // Clear database
  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('posts');
  }
}
