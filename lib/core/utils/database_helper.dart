import 'package:sqflite/sqflite.dart' hide DatabaseException;
import 'package:path/path.dart';
import '../../../core/constants/database_constants.dart';
import '../errors/exceptions.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._internal();
    return _instance!;
  }

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      final documentsDirectory = await getDatabasesPath();
      final path = join(documentsDirectory, DatabaseConstants.databaseName);

      return await openDatabase(
        path,
        version: DatabaseConstants.databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onOpen: _onOpen,
      );
    } catch (e) {
      throw DatabaseException('Failed to initialize database: ${e.toString()}');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.transaction((txn) async {
      // Create projects table
      await txn.execute('''
        CREATE TABLE ${DatabaseConstants.projectsTable} (
          ${DatabaseConstants.columnId} TEXT PRIMARY KEY,
          ${DatabaseConstants.columnServerId} TEXT UNIQUE,
          ${DatabaseConstants.columnProjectName} TEXT NOT NULL,
          ${DatabaseConstants.columnProjectDescription} TEXT,
          ${DatabaseConstants.columnProjectColor} TEXT,
          ${DatabaseConstants.columnSyncStatus} TEXT NOT NULL DEFAULT 'pending',
          ${DatabaseConstants.columnCreatedAt} TEXT NOT NULL,
          ${DatabaseConstants.columnUpdatedAt} TEXT NOT NULL,
          ${DatabaseConstants.columnDeletedAt} TEXT,
          ${DatabaseConstants.columnLastSyncAt} TEXT
        )
      ''');

      // Create tasks table
      await txn.execute('''
        CREATE TABLE ${DatabaseConstants.tasksTable} (
          ${DatabaseConstants.columnId} TEXT PRIMARY KEY,
          ${DatabaseConstants.columnServerId} TEXT UNIQUE,
          ${DatabaseConstants.columnTaskTitle} TEXT NOT NULL,
          ${DatabaseConstants.columnTaskDescription} TEXT,
          ${DatabaseConstants.columnTaskStatus} TEXT NOT NULL DEFAULT 'pending',
          ${DatabaseConstants.columnTaskPriority} TEXT NOT NULL DEFAULT 'medium',
          ${DatabaseConstants.columnTaskDueDate} TEXT,
          ${DatabaseConstants.columnTaskProjectId} TEXT NOT NULL,
          ${DatabaseConstants.columnTaskCompletedAt} TEXT,
          ${DatabaseConstants.columnSyncStatus} TEXT NOT NULL DEFAULT 'pending',
          ${DatabaseConstants.columnCreatedAt} TEXT NOT NULL,
          ${DatabaseConstants.columnUpdatedAt} TEXT NOT NULL,
          ${DatabaseConstants.columnDeletedAt} TEXT,
          ${DatabaseConstants.columnLastSyncAt} TEXT,
          FOREIGN KEY (${DatabaseConstants.columnTaskProjectId}) 
            REFERENCES ${DatabaseConstants.projectsTable} (${DatabaseConstants.columnId})
            ON DELETE CASCADE
        )
      ''');

      // Create indexes for better performance
      await _createIndexes(txn);
    });
  }

  Future<void> _createIndexes(Transaction txn) async {
    // Projects indexes
    await txn.execute('''
      CREATE INDEX idx_projects_sync_status 
      ON ${DatabaseConstants.projectsTable} (${DatabaseConstants.columnSyncStatus})
    ''');

    await txn.execute('''
      CREATE INDEX idx_projects_deleted_at 
      ON ${DatabaseConstants.projectsTable} (${DatabaseConstants.columnDeletedAt})
    ''');

    await txn.execute('''
      CREATE INDEX idx_projects_server_id 
      ON ${DatabaseConstants.projectsTable} (${DatabaseConstants.columnServerId})
    ''');

    // Tasks indexes
    await txn.execute('''
      CREATE INDEX idx_tasks_project_id 
      ON ${DatabaseConstants.tasksTable} (${DatabaseConstants.columnTaskProjectId})
    ''');

    await txn.execute('''
      CREATE INDEX idx_tasks_status 
      ON ${DatabaseConstants.tasksTable} (${DatabaseConstants.columnTaskStatus})
    ''');

    await txn.execute('''
      CREATE INDEX idx_tasks_priority 
      ON ${DatabaseConstants.tasksTable} (${DatabaseConstants.columnTaskPriority})
    ''');

    await txn.execute('''
      CREATE INDEX idx_tasks_due_date 
      ON ${DatabaseConstants.tasksTable} (${DatabaseConstants.columnTaskDueDate})
    ''');

    await txn.execute('''
      CREATE INDEX idx_tasks_sync_status 
      ON ${DatabaseConstants.tasksTable} (${DatabaseConstants.columnSyncStatus})
    ''');

    await txn.execute('''
      CREATE INDEX idx_tasks_deleted_at 
      ON ${DatabaseConstants.tasksTable} (${DatabaseConstants.columnDeletedAt})
    ''');

    await txn.execute('''
      CREATE INDEX idx_tasks_server_id 
      ON ${DatabaseConstants.tasksTable} (${DatabaseConstants.columnServerId})
    ''');

    // Composite indexes for common queries
    await txn.execute('''
      CREATE INDEX idx_tasks_project_status 
      ON ${DatabaseConstants.tasksTable} (
        ${DatabaseConstants.columnTaskProjectId}, 
        ${DatabaseConstants.columnTaskStatus}
      )
    ''');

    await txn.execute('''
      CREATE INDEX idx_tasks_search 
      ON ${DatabaseConstants.tasksTable} (
        ${DatabaseConstants.columnTaskTitle}, 
        ${DatabaseConstants.columnDeletedAt}
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    // This is where you'd add migration logic for future versions
  }

  Future<void> _onOpen(Database db) async {
    // Enable foreign key constraints
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // Generic CRUD operations with error handling
  Future<int> insert(String table, Map<String, dynamic> values) async {
    try {
      final db = await database;
      return await db.insert(table, values);
    } catch (e) {
      throw DatabaseException('Failed to insert into $table: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> query(
      String table, {
        bool? distinct,
        List<String>? columns,
        String? where,
        List<dynamic>? whereArgs,
        String? groupBy,
        String? having,
        String? orderBy,
        int? limit,
        int? offset,
      }) async {
    try {
      final db = await database;
      return await db.query(
        table,
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );
    } catch (e) {
      throw DatabaseException('Failed to query $table: ${e.toString()}');
    }
  }

  Future<int> update(
      String table,
      Map<String, dynamic> values, {
        String? where,
        List<dynamic>? whereArgs,
      }) async {
    try {
      final db = await database;
      return await db.update(table, values, where: where, whereArgs: whereArgs);
    } catch (e) {
      throw DatabaseException('Failed to update $table: ${e.toString()}');
    }
  }

  Future<int> delete(
      String table, {
        String? where,
        List<dynamic>? whereArgs,
      }) async {
    try {
      final db = await database;
      return await db.delete(table, where: where, whereArgs: whereArgs);
    } catch (e) {
      throw DatabaseException('Failed to delete from $table: ${e.toString()}');
    }
  }

  // Transaction support
  Future<T> transaction<T>(Future<T> Function(Transaction txn) action) async {
    try {
      final db = await database;
      return await db.transaction(action);
    } catch (e) {
      throw DatabaseException('Transaction failed: ${e.toString()}');
    }
  }

  // Raw query support
  Future<List<Map<String, dynamic>>> rawQuery(
      String sql, [
        List<dynamic>? arguments,
      ]) async {
    try {
      final db = await database;
      return await db.rawQuery(sql, arguments);
    } catch (e) {
      throw DatabaseException('Raw query failed: ${e.toString()}');
    }
  }

  // Batch operations for sync
  Future<void> batch(Function(Batch batch) operations) async {
    try {
      final db = await database;
      final batch = db.batch();
      operations(batch);
      await batch.commit(noResult: true);
    } catch (e) {
      throw DatabaseException('Batch operation failed: ${e.toString()}');
    }
  }

  // Close database connection
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  // Clear all data (useful for testing or reset)
  Future<void> clearAllData() async {
    try {
      await transaction((txn) async {
        await txn.delete(DatabaseConstants.tasksTable);
        await txn.delete(DatabaseConstants.projectsTable);
      });
    } catch (e) {
      throw DatabaseException('Failed to clear data: ${e.toString()}');
    }
  }
}