// import '../../../core/constants/database_constants.dart';
// import '../../../core/enums/sync_status.dart';
// import '../../../core/utils/database_helper.dart';
// import '../../models/project_model.dart';
//
// abstract class ProjectLocalDataSource {
//   Future<ProjectModel> createProject(ProjectModel project);
//
//   Future<ProjectModel?> getProject(String id);
//
//   Future<List<ProjectModel>> getProjects({
//     int page = 1,
//     int pageSize = DatabaseConstants.defaultPageSize,
//     String? sortBy = 'created_at',
//     bool ascending = false,
//     bool includeDeleted = false,
//   });
//
//   Future<List<ProjectModel>> searchProjects(
//     String query, {
//     int page = 1,
//     int pageSize = DatabaseConstants.defaultPageSize,
//   });
//
//   Future<ProjectModel> updateProject(ProjectModel project);
//
//   Future<void> deleteProject(String id, {bool softDelete = true});
//
//   Future<void> hardDeleteProject(String id);
//
//   Future<List<ProjectModel>> getUnsyncedProjects();
//
//   Future<ProjectModel?> getProjectByServerId(String serverId);
//
//   Future<int> getProjectsCount({bool includeDeleted = false});
// }
//
// class ProjectLocalDataSourceImpl implements ProjectLocalDataSource {
//   final DatabaseHelper _databaseHelper;
//
//   ProjectLocalDataSourceImpl(this._databaseHelper);
//
//   @override
//   Future<ProjectModel> createProject(ProjectModel project) async {
//     await _databaseHelper.insert(
//       DatabaseConstants.projectsTable,
//       project.toMap(),
//     );
//     return project;
//   }
//
//   @override
//   Future<ProjectModel?> getProject(String id) async {
//     final results = await _databaseHelper.query(
//       DatabaseConstants.projectsTable,
//       where:
//           '${DatabaseConstants.columnId} = ? AND ${DatabaseConstants.columnDeletedAt} IS NULL',
//       whereArgs: [id],
//     );
//
//     if (results.isEmpty) return null;
//     return ProjectModel.fromMap(results.first);
//   }
//
//   @override
//   Future<List<ProjectModel>> getProjects({
//     int page = 1,
//     int pageSize = DatabaseConstants.defaultPageSize,
//     String? sortBy = 'created_at',
//     bool ascending = false,
//     bool includeDeleted = false,
//   }) async {
//     final validPageSize = pageSize.clamp(1, DatabaseConstants.maxPageSize);
//     final offset = (page - 1) * validPageSize;
//     final sortDirection = ascending ? 'ASC' : 'DESC';
//
//     // Validate sortBy column
//     final validSortColumns = [
//       'created_at',
//       'updated_at',
//       'name',
//       DatabaseConstants.columnCreatedAt,
//       DatabaseConstants.columnUpdatedAt,
//       DatabaseConstants.columnProjectName,
//     ];
//     final orderBy =
//         validSortColumns.contains(sortBy)
//             ? '$sortBy $sortDirection'
//             : 'created_at DESC';
//
//     String where =
//         includeDeleted ? '' : '${DatabaseConstants.columnDeletedAt} IS NULL';
//
//     final results = await _databaseHelper.query(
//       DatabaseConstants.projectsTable,
//       where: where.isEmpty ? null : where,
//       orderBy: orderBy,
//       limit: validPageSize,
//       offset: offset,
//     );
//
//     return results.map((map) => ProjectModel.fromMap(map)).toList();
//   }
//
//   @override
//   Future<List<ProjectModel>> searchProjects(
//     String query, {
//     int page = 1,
//     int pageSize = DatabaseConstants.defaultPageSize,
//   }) async {
//     if (query.trim().isEmpty) {
//       return getProjects(page: page, pageSize: pageSize);
//     }
//
//     final validPageSize = pageSize.clamp(1, DatabaseConstants.maxPageSize);
//     final offset = (page - 1) * validPageSize;
//     final searchQuery = '%${query.toLowerCase()}%';
//
//     final results = await _databaseHelper.query(
//       DatabaseConstants.projectsTable,
//       where: '''
//         ${DatabaseConstants.columnDeletedAt} IS NULL AND
//         (LOWER(${DatabaseConstants.columnProjectName}) LIKE ? OR
//          LOWER(${DatabaseConstants.columnProjectDescription}) LIKE ?)
//       ''',
//       whereArgs: [searchQuery, searchQuery],
//       orderBy: '${DatabaseConstants.columnUpdatedAt} DESC',
//       limit: validPageSize,
//       offset: offset,
//     );
//
//     return results.map((map) => ProjectModel.fromMap(map)).toList();
//   }
//
//   @override
//   Future<ProjectModel> updateProject(ProjectModel project) async {
//     final updatedProject = project.copyWith(
//       updatedAt: DateTime.now(),
//       syncStatus: SyncStatus.pending,
//     );
//
//     await _databaseHelper.update(
//       DatabaseConstants.projectsTable,
//       updatedProject.toMap(),
//       where: '${DatabaseConstants.columnId} = ?',
//       whereArgs: [project.id],
//     );
//
//     return updatedProject;
//   }
//
//   @override
//   Future<void> deleteProject(String id, {bool softDelete = true}) async {
//     if (softDelete) {
//       // Soft delete - mark as deleted but keep the record
//       final now = DateTime.now();
//       await _databaseHelper.update(
//         DatabaseConstants.projectsTable,
//         {
//           DatabaseConstants.columnDeletedAt: now.toIso8601String(),
//           DatabaseConstants.columnUpdatedAt: now.toIso8601String(),
//           DatabaseConstants.columnSyncStatus: SyncStatus.pending.name,
//         },
//         where: '${DatabaseConstants.columnId} = ?',
//         whereArgs: [id],
//       );
//
//       // Also soft delete all associated tasks
//       await _databaseHelper.update(
//         DatabaseConstants.tasksTable,
//         {
//           DatabaseConstants.columnDeletedAt: now.toIso8601String(),
//           DatabaseConstants.columnUpdatedAt: now.toIso8601String(),
//           DatabaseConstants.columnSyncStatus: SyncStatus.pending.name,
//         },
//         where:
//             '${DatabaseConstants.columnTaskProjectId} = ? AND ${DatabaseConstants.columnDeletedAt} IS NULL',
//         whereArgs: [id],
//       );
//     } else {
//       await hardDeleteProject(id);
//     }
//   }
//
//   @override
//   Future<void> hardDeleteProject(String id) async {
//     await _databaseHelper.transaction((txn) async {
//       // Delete all tasks in this project first (due to foreign key)
//       await txn.delete(
//         DatabaseConstants.tasksTable,
//         where: '${DatabaseConstants.columnTaskProjectId} = ?',
//         whereArgs: [id],
//       );
//
//       // Then delete the project
//       await txn.delete(
//         DatabaseConstants.projectsTable,
//         where: '${DatabaseConstants.columnId} = ?',
//         whereArgs: [id],
//       );
//     });
//   }
//
//   @override
//   Future<List<ProjectModel>> getUnsyncedProjects() async {
//     final results = await _databaseHelper.query(
//       DatabaseConstants.projectsTable,
//       where: '${DatabaseConstants.columnSyncStatus} != ?',
//       whereArgs: [SyncStatus.synced.name],
//       orderBy: '${DatabaseConstants.columnUpdatedAt} ASC',
//     );
//
//     return results.map((map) => ProjectModel.fromMap(map)).toList();
//   }
//
//   @override
//   Future<ProjectModel?> getProjectByServerId(String serverId) async {
//     final results = await _databaseHelper.query(
//       DatabaseConstants.projectsTable,
//       where: '${DatabaseConstants.columnServerId} = ?',
//       whereArgs: [serverId],
//     );
//
//     if (results.isEmpty) return null;
//     return ProjectModel.fromMap(results.first);
//   }
//
//   @override
//   Future<int> getProjectsCount({bool includeDeleted = false}) async {
//     String where =
//         includeDeleted ? '' : '${DatabaseConstants.columnDeletedAt} IS NULL';
//
//     final result = await _databaseHelper.rawQuery(
//       'SELECT COUNT(*) as count FROM ${DatabaseConstants.projectsTable}${where.isEmpty ? '' : ' WHERE $where'}',
//     );
//
//     return result.first['count'] as int;
//   }
//
// }
