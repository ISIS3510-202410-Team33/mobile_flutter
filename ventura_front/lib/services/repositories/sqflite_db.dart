import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class LocalDB {
  static Database? _database;
  static final LocalDB instance = LocalDB._privateConstructor();

  LocalDB._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'local.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE courses (
        id INTEGER PRIMARY KEY,
        name TEXT,
        room TEXT,
        professor TEXT,
        schedule TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE grades (
        id INTEGER PRIMARY KEY,
        courseId INTEGER,
        grade REAL,
        percentage REAL,
        name TEXT,
        FOREIGN KEY (courseId) REFERENCES courses (id) ON DELETE NO ACTION ON UPDATE NO ACTION
      )
    ''');
  }

  Future<void> close() async {
    Database db = await database;
    db.close();
  }

  Future<void> delete() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'local.db');
    await deleteDatabase(path);
  }
}