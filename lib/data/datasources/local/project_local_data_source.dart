import '../../../core/errors/exceptions.dart';
import '../../../core/utils/paginated_result.dart';
import '../../models/project_model.dart';
import 'database_helper.dart';

abstract class ProjectLocalDataSource {
  Future<ProjectModel> create(ProjectModel project);
  Future<ProjectModel?> getById(int id);
  Future<PaginatedResult<ProjectModel>> getAll({int page = 1, int pageSize = 10});
  Future<PaginatedResult<ProjectModel>> search(String query, {int page = 1, int pageSize = 10});
  Future<ProjectModel> update(ProjectModel project);
  Future<ProjectModel> updateProjectStats(int projectId);
  Future<void> delete(int id);
}

class ProjectLocalDataSourceImpl implements ProjectLocalDataSource {
  final DatabaseHelper _databaseHelper;

  ProjectLocalDataSourceImpl(this._databaseHelper);

  @override
  Future<ProjectModel> create(ProjectModel project) async {
    try {
      final db = await _databaseHelper.database;
      final id = await db.insert('projects', project.toMap()..remove('id'));
      final created = await getById(id);
      return created!;
    } catch (e) {
      throw DatabaseException('Failed to create project: $e');
    }
  }

  @override
  Future<ProjectModel?> getById(int id) async {
    try {
      final db = await _databaseHelper.database;
      final maps = await db.query('projects', where: 'id = ?', whereArgs: [id]);
      return maps.isNotEmpty ? ProjectModel.fromMap(maps.first) : null;
    } catch (e) {
      throw DatabaseException('Failed to get project: $e');
    }
  }

  @override
  Future<PaginatedResult<ProjectModel>> getAll({int page = 1, int pageSize = 10}) async {
    try {
      final db = await _databaseHelper.database;
      final offset = (page - 1) * pageSize;

      final countResult = await db.rawQuery('SELECT COUNT(*) as count FROM projects');
      final totalCount = countResult.first['count'] as int;

      final maps = await db.query(
        'projects',
        orderBy: 'createdAt DESC',
        limit: pageSize,
        offset: offset,
      );

      final projects = maps.map((map) => ProjectModel.fromMap(map)).toList();

      return PaginatedResult<ProjectModel>(
        items: projects,
        page: page,
        pageSize: pageSize,
        totalCount: totalCount,
      );
    } catch (e) {
      throw DatabaseException('Failed to get projects: $e');
    }
  }

  @override
  Future<PaginatedResult<ProjectModel>> search(String query, {int page = 1, int pageSize = 10}) async {
    try {
      final db = await _databaseHelper.database;
      final offset = (page - 1) * pageSize;
      final searchQuery = '%$query%';

      final countResult = await db.rawQuery(
        'SELECT COUNT(*) as count FROM projects WHERE name LIKE ? OR description LIKE ?',
        [searchQuery, searchQuery],
      );
      final totalCount = countResult.first['count'] as int;

      final maps = await db.query(
        'projects',
        where: 'name LIKE ? OR description LIKE ?',
        whereArgs: [searchQuery, searchQuery],
        orderBy: 'createdAt DESC',
        limit: pageSize,
        offset: offset,
      );

      final projects = maps.map((map) => ProjectModel.fromMap(map)).toList();

      return PaginatedResult<ProjectModel>(
        items: projects,
        page: page,
        pageSize: pageSize,
        totalCount: totalCount,
      );
    } catch (e) {
      throw DatabaseException('Failed to search projects: $e');
    }
  }

  @override
  Future<ProjectModel> update(ProjectModel project) async {
    try {
      final db = await _databaseHelper.database;
      await db.update(
        'projects',
        project.toMap(),
        where: 'id = ?',
        whereArgs: [project.id],
      );
      return (await getById(project.id!))!;
    } catch (e) {
      throw DatabaseException('Failed to update project: $e');
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      final db = await _databaseHelper.database;
      await db.delete('projects', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw DatabaseException('Failed to delete project: $e');
    }
  }

  @override
  Future<ProjectModel> updateProjectStats(int projectId) async {
    try {
      final db = await _databaseHelper.database;

      // Get task counts
      final taskCounts = await db.rawQuery('''
      SELECT 
        COUNT(*) as total,
        SUM(CASE WHEN status = 'complete' THEN 1 ELSE 0 END) as completed
      FROM tasks WHERE projectId = ?
    ''', [projectId]);

      final total = taskCounts.first['total'] as int;
      final completed = taskCounts.first['completed'] as int;
      final progress = total > 0 ? completed / total : 0.0;

      // Update project
      await db.update(
        'projects',
        {
          'tasksCount': total,
          'completedTasks': completed,
          'progress': progress,
          'updatedAt': DateTime.now().millisecondsSinceEpoch,
        },
        where: 'id = ?',
        whereArgs: [projectId],
      );

      return (await getById(projectId))!;
    } catch (e) {
      throw DatabaseException('Failed to update project stats: $e');
    }
  }

}
