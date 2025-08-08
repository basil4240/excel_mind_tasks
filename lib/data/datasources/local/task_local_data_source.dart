import '../../../core/errors/exceptions.dart';
import '../../../core/utils/paginated_result.dart';
import '../../models/task_model.dart';
import 'database_helper.dart';

abstract class TaskLocalDataSource {
  Future<TaskModel> create(TaskModel task);

  Future<TaskModel?> getById(int id);

  Future<PaginatedResult<TaskModel>> getAll({int page = 1, int pageSize = 10});

  Future<PaginatedResult<TaskModel>> search(
    String query, {
    int page = 1,
    int pageSize = 10,
  });

  Future<TaskModel> update(TaskModel task);

  Future<void> delete(int id);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final DatabaseHelper _databaseHelper;

  TaskLocalDataSourceImpl(this._databaseHelper);

  @override
  Future<TaskModel> create(TaskModel task) async {
    try {
      final db = await _databaseHelper.database;
      final id = await db.insert('tasks', task.toMap()..remove('id'));

      final maps = await db.rawQuery(
        '''
      SELECT tasks.*, projects.name as projectName
      FROM tasks
      LEFT JOIN projects ON tasks.projectId = projects.id
      WHERE tasks.id = ?
      ''',
        [id],
      );

      if (maps.isNotEmpty) {
        return TaskModel.fromMap(maps.first);
      } else {
        throw DatabaseException(
          'Failed to retrieve created task with projectName',
        );
      }
    } catch (e) {
      throw DatabaseException('Failed to create task: $e');
    }
  }

  // @override
  // Future<TaskModel> create(TaskModel task) async {
  //   try {
  //     final db = await _databaseHelper.database;
  //     final id = await db.insert('tasks', task.toMap()..remove('id'));
  //     final created = await getById(id);
  //     return created!;
  //   } catch (e) {
  //     throw DatabaseException('Failed to create task: $e');
  //   }
  // }

  @override
  Future<TaskModel?> getById(int id) async {
    try {
      final db = await _databaseHelper.database;
      final maps = await db.query('tasks', where: 'id = ?', whereArgs: [id]);
      return maps.isNotEmpty ? TaskModel.fromMap(maps.first) : null;
    } catch (e) {
      throw DatabaseException('Failed to get task: $e');
    }
  }

  @override
  Future<PaginatedResult<TaskModel>> getAll({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final db = await _databaseHelper.database;
      final offset = (page - 1) * pageSize;

      final countResult = await db.rawQuery(
        'SELECT COUNT(*) as count FROM tasks',
      );
      final totalCount = countResult.first['count'] as int;

      final maps = await db.rawQuery(
        '''
      SELECT tasks.*, projects.name as projectName
      FROM tasks
      LEFT JOIN projects ON tasks.projectId = projects.id
      ORDER BY tasks.createdAt DESC
      LIMIT ? OFFSET ?
    ''',
        [pageSize, offset],
      );

      final tasks = maps.map((map) => TaskModel.fromMap(map)).toList();

      return PaginatedResult<TaskModel>(
        items: tasks,
        page: page,
        pageSize: pageSize,
        totalCount: totalCount,
      );
    } catch (e) {
      throw DatabaseException('Failed to get tasks: $e');
    }
  }

  // @override
  // Future<PaginatedResult<TaskModel>> getAll({int page = 1, int pageSize = 10}) async {
  //   try {
  //     final db = await _databaseHelper.database;
  //     final offset = (page - 1) * pageSize;
  //
  //     final countResult = await db.rawQuery('SELECT COUNT(*) as count FROM tasks');
  //     final totalCount = countResult.first['count'] as int;
  //
  //     final maps = await db.query(
  //       'tasks',
  //       orderBy: 'createdAt DESC',
  //       limit: pageSize,
  //       offset: offset,
  //     );
  //
  //     final tasks = maps.map((map) => TaskModel.fromMap(map)).toList();
  //
  //     return PaginatedResult<TaskModel>(
  //       items: tasks,
  //       page: page,
  //       pageSize: pageSize,
  //       totalCount: totalCount,
  //     );
  //   } catch (e) {
  //     throw DatabaseException('Failed to get tasks: $e');
  //   }
  // }

  // @override
  // Future<PaginatedResult<TaskModel>> search(
  //   String query, {
  //   int page = 1,
  //   int pageSize = 10,
  // }) async {
  //   try {
  //     final db = await _databaseHelper.database;
  //     final offset = (page - 1) * pageSize;
  //     final searchQuery = '%$query%';
  //
  //     final countResult = await db.rawQuery(
  //       'SELECT COUNT(*) as count FROM tasks WHERE title LIKE ? OR description LIKE ?',
  //       [searchQuery, searchQuery],
  //     );
  //     final totalCount = countResult.first['count'] as int;
  //
  //     final maps = await db.query(
  //       'tasks',
  //       where: 'title LIKE ? OR description LIKE ?',
  //       whereArgs: [searchQuery, searchQuery],
  //       orderBy: 'createdAt DESC',
  //       limit: pageSize,
  //       offset: offset,
  //     );
  //
  //     final tasks = maps.map((map) => TaskModel.fromMap(map)).toList();
  //
  //     return PaginatedResult<TaskModel>(
  //       items: tasks,
  //       page: page,
  //       pageSize: pageSize,
  //       totalCount: totalCount,
  //     );
  //   } catch (e) {
  //     throw DatabaseException('Failed to search tasks: $e');
  //   }
  // }

  @override
  Future<PaginatedResult<TaskModel>> search(
    String query, {
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final db = await _databaseHelper.database;
      final offset = (page - 1) * pageSize;
      final searchQuery = '%$query%';

      final countResult = await db.rawQuery(
        '''
      SELECT COUNT(*) as count 
      FROM tasks 
      LEFT JOIN projects ON tasks.projectId = projects.id 
      WHERE tasks.title LIKE ? OR tasks.description LIKE ?
      ''',
        [searchQuery, searchQuery],
      );
      final totalCount = countResult.first['count'] as int;

      final maps = await db.rawQuery(
        '''
      SELECT tasks.*, projects.name as projectName 
      FROM tasks 
      LEFT JOIN projects ON tasks.projectId = projects.id 
      WHERE tasks.title LIKE ? OR tasks.description LIKE ? 
      ORDER BY tasks.createdAt DESC 
      LIMIT ? OFFSET ?
      ''',
        [searchQuery, searchQuery, pageSize, offset],
      );

      final tasks = maps.map((map) => TaskModel.fromMap(map)).toList();

      return PaginatedResult<TaskModel>(
        items: tasks,
        page: page,
        pageSize: pageSize,
        totalCount: totalCount,
      );
    } catch (e) {
      throw DatabaseException('Failed to search tasks: $e');
    }
  }

  // @override
  // Future<TaskModel> update(TaskModel task) async {
  //   try {
  //     final db = await _databaseHelper.database;
  //     await db.update(
  //       'tasks',
  //       task.toMap(),
  //       where: 'id = ?',
  //       whereArgs: [task.id],
  //     );
  //     return (await getById(task.id!))!;
  //   } catch (e) {
  //     throw DatabaseException('Failed to update task: $e');
  //   }
  // }

  @override
  Future<TaskModel> update(TaskModel task) async {
    try {
      final db = await _databaseHelper.database;
      await db.update(
        'tasks',
        task.toMap(),
        where: 'id = ?',
        whereArgs: [task.id],
      );

      final maps = await db.rawQuery(
        '''
      SELECT tasks.*, projects.name as projectName
      FROM tasks
      LEFT JOIN projects ON tasks.projectId = projects.id
      WHERE tasks.id = ?
      ''',
        [task.id],
      );

      if (maps.isNotEmpty) {
        return TaskModel.fromMap(maps.first);
      } else {
        throw DatabaseException(
          'Failed to retrieve updated task with projectName',
        );
      }
    } catch (e) {
      throw DatabaseException('Failed to update task: $e');
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      final db = await _databaseHelper.database;
      await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw DatabaseException('Failed to delete task: $e');
    }
  }
}
