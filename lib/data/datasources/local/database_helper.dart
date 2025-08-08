import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'database_seeder.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'todo_app');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE projects (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        color TEXT,
        startedAt INTEGER,
        endedAt INTEGER,
        tasksCount INTEGER NOT NULL DEFAULT 0,
        completedTasks INTEGER NOT NULL DEFAULT 0,
        progress REAL NOT NULL DEFAULT 0.0,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        status TEXT NOT NULL DEFAULT 'incomplete',
        priority TEXT NOT NULL DEFAULT 'low',
        dueDate INTEGER,
        projectId INTEGER,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL,
        FOREIGN KEY (projectId) REFERENCES projects (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('CREATE INDEX idx_tasks_project_id ON tasks(projectId)');
    await db.execute('CREATE INDEX idx_tasks_status ON tasks(status)');
    await db.execute('CREATE INDEX idx_tasks_priority ON tasks(priority)');

    // Seed the database with dummy data
    debugPrint('Seeding database with dummy data...');
    await DatabaseSeeder.seedDatabase(db);
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }

  // Optional: Method to manually seed database (useful for testing)
  Future<void> seedDatabaseManually() async {
    final db = await database;

    // Check if data already exists
    final projectCount =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM projects'),
        ) ??
        0;

    if (projectCount == 0) {
      await DatabaseSeeder.seedDatabase(db);
    } else {
      debugPrint('Database already contains data. Skipping seeding.');
    }
  }

  // Optional: Method to clear all data and reseed (useful for development)
  Future<void> clearAndReseed() async {
    final db = await database;
    await db.delete('tasks');
    await db.delete('projects');
    await DatabaseSeeder.seedDatabase(db);
  }
}

// class DatabaseHelper {
//   static final DatabaseHelper _instance = DatabaseHelper._internal();
//   static Database? _database;
//
//   DatabaseHelper._internal();
//
//   factory DatabaseHelper() => _instance;
//
//   Future<Database> get database async {
//     _database ??= await _initDatabase();
//     return _database!;
//   }
//
//   Future<Database> _initDatabase() async {
//     String path = join(await getDatabasesPath(), 'todo_app.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _onCreate,
//     );
//   }
//
//   Future<void> _onCreate(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE projects (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         name TEXT NOT NULL,
//         description TEXT,
//         color TEXT,
//         startedAt INTEGER,
//         endedAt INTEGER,
//         createdAt INTEGER NOT NULL,
//         updatedAt INTEGER NOT NULL
//       )
//     ''');
//
//     await db.execute('''
//       CREATE TABLE tasks (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         title TEXT NOT NULL,
//         description TEXT,
//         status TEXT NOT NULL DEFAULT 'incomplete',
//         priority TEXT NOT NULL DEFAULT 'low',
//         dueDate INTEGER,
//         projectId INTEGER,
//         createdAt INTEGER NOT NULL,
//         updatedAt INTEGER NOT NULL,
//         FOREIGN KEY (projectId) REFERENCES projects (id) ON DELETE CASCADE
//       )
//     ''');
//
//     await db.execute('CREATE INDEX idx_tasks_project_id ON tasks(projectId)');
//     await db.execute('CREATE INDEX idx_tasks_status ON tasks(status)');
//     await db.execute('CREATE INDEX idx_tasks_priority ON tasks(priority)');
//   }
//
//   Future<void> close() async {
//     final db = await database;
//     db.close();
//   }
// }
