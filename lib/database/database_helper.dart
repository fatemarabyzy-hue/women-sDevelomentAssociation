import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/course.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('courses.db');
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

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'INTEGER NOT NULL DEFAULT 1';
    const boolTypeDefault0 = 'INTEGER NOT NULL DEFAULT 0';

    await db.execute('''
      CREATE TABLE courses (
        id $idType,
        title $textType,
        description $textType,
        imageUrl $textType,
        duration $textType,
        dateRange $textType,
        instructor $textType,
        category $textType,
        isActive $boolType,
        isFavorite $boolTypeDefault0
      )
    ''');
  }

  Future<int> insertCourse(Course course) async {
    final db = await instance.database;
    return await db.insert('courses', course.toMap());
  }

  Future<List<Course>> getAllCourses() async {
    final db = await instance.database;
    final result = await db.query('courses', orderBy: 'id DESC');
    return result.map((json) => Course.fromMap(json)).toList();
  }

  Future<List<Course>> getFavoriteCourses() async {
    final db = await instance.database;
    final result = await db.query(
      'courses',
      where: 'isFavorite = ?',
      whereArgs: [1],
      orderBy: 'id DESC',
    );
    return result.map((json) => Course.fromMap(json)).toList();
  }

  Future<Course?> getCourse(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'courses',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Course.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> updateCourse(Course course) async {
    final db = await instance.database;
    return await db.update(
      'courses',
      course.toMap(),
      where: 'id = ?',
      whereArgs: [course.id],
    );
  }

  Future<int> toggleFavorite(int id, bool isFavorite) async {
    final db = await instance.database;
    return await db.update(
      'courses',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCourse(int id) async {
    final db = await instance.database;
    return await db.delete(
      'courses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
    _database = null;
  }
}

