// import '../../../core/constants/database_constants.dart';
// import '../../../core/enums/priority.dart';
// import '../../../core/enums/sync_status.dart';
// import '../../../core/enums/task_status.dart';
// import '../../../core/utils/database_helper.dart';
// import '../../models/task_model.dart';
//
// abstract class TaskLocalDataSource {
//   Future<TaskModel> createTask(TaskModel task);
//
//   Future<TaskModel?> getTask(String id);
//
//   Future<List<TaskModel>> getTasks({
//     int page = 1,
//     int pageSize = DatabaseConstants.defaultPageSize,
//     String? projectId,
//     TaskStatus? status,
//     Priority? priority,
//     String? sortBy = 'created_at',
//     bool ascending = false,
//     bool includeDeleted = false,
//   });
//
//   Future<List<TaskModel>> searchTasks(
//     String query, {
//     int page = 1,
//     int pageSize = DatabaseConstants.defaultPageSize,
//     String? projectId,
//   });
//
//   Future<TaskModel> updateTask(TaskModel task);
//
//   Future<void> deleteTask(String id, {bool softDelete = true});
//
//   Future<void> hardDeleteTask(String id);
//
//   Future<List<TaskModel>> getUnsyncedTasks();
//
//   Future<TaskModel?> getTaskByServerId(String serverId);
//
//   Future<int> getTasksCount({
//     String? projectId,
//     TaskStatus? status,
//     bool includeDeleted = false,
//   });
//
//   Future<List<TaskModel>> getOverdueTasks();
//
//   Future<TaskModel> toggleTaskStatus(String id);
// }
//
// class TaskLocalDataSourceImpl implements TaskLocalDataSource {
//   final DatabaseHelper _databaseHelper;
//
//   TaskLocalDataSourceImpl(this._databaseHelper);
//
//   @override
//   Future<TaskModel> createTask(TaskModel task) async {
//     await _databaseHelper.insert(DatabaseConstants.tasksTable, task.toMap());
//     return task;
//   }
//
//   @override
//   Future<TaskModel?> getTask(String id) async {
//     final results = await _databaseHelper.query(
//       DatabaseConstants.tasksTable,
//       where:
//           '${DatabaseConstants.columnId} = ? AND ${DatabaseConstants.columnDeletedAt} IS NULL',
//       whereArgs: [id],
//     );
//
//     if (results.isEmpty) return null;
//     return TaskModel.fromMap(results.first);
//   }
//
//   @override
//   Future<List<TaskModel>> getTasks({
//     int page = 1,
//     int pageSize = DatabaseConstants.defaultPageSize,
//     String? projectId,
//     TaskStatus? status,
//     Priority? priority,
//     String? sortBy = 'created_at',
//     bool ascending = false,
//     bool includeDeleted = false,
//   }) async {
//     final validPageSize = pageSize.clamp(1, DatabaseConstants.maxPageSize);
//     final offset = (page - 1) * validPageSize;
//     final sortDirection = ascending ? 'ASC' : 'DESC';
//
//     // Build WHERE clause
//     final whereConditions = <String>[];
//     final whereArgs = <dynamic>[];
//
//     if (!includeDeleted) {
//       whereConditions.add('${DatabaseConstants.columnDeletedAt} IS NULL');
//     }
//
//     if (projectId != null) {
//       whereConditions.add('${DatabaseConstants.columnTaskProjectId} = ?');
//       whereArgs.add(projectId);
//     }
//
//     if (status != null) {
//       whereConditions.add('${DatabaseConstants.columnTaskStatus} = ?');
//       whereArgs.add(status.name);
//     }
//
//     if (priority != null) {
//       whereConditions.add('${DatabaseConstants.columnTaskPriority} = ?');
//       whereArgs.add(priority.name);
//     }
//
//     // Validate sortBy column
//     final validSortColumns = [
//       'created_at',
//       'updated_at',
//       'title',
//       'due_date',
//       'priority',
//       'status',
//       DatabaseConstants.columnCreatedAt,
//       DatabaseConstants.columnUpdatedAt,
//       DatabaseConstants.columnTaskTitle,
//       DatabaseConstants.columnTaskDueDate,
//       DatabaseConstants.columnTaskPriority,
//       DatabaseConstants.columnTaskStatus,
//     ];
//     final orderBy =
//         validSortColumns.contains(sortBy)
//             ? '$sortBy $sortDirection'
//             : 'created_at DESC';
//
//     final results = await _databaseHelper.query(
//       DatabaseConstants.tasksTable,
//       where: whereConditions.isEmpty ? null : whereConditions.join(' AND '),
//       whereArgs: whereArgs.isEmpty ? null : whereArgs,
//       orderBy: orderBy,
//       limit: validPageSize,
//       offset: offset,
//     );
//
//     return results.map((map) => TaskModel.fromMap(map)).toList();
//   }
//
//   @override
//   Future<List<TaskModel>> searchTasks(
//     String query, {
//     int page = 1,
//     int pageSize = DatabaseConstants.defaultPageSize,
//     String? projectId,
//   }) async {
//     if (query.trim().isEmpty) {
//       return getTasks(page: page, pageSize: pageSize, projectId: projectId);
//     }
//
//     final validPageSize = pageSize.clamp(1, DatabaseConstants.maxPageSize);
//     final offset = (page - 1) * validPageSize;
//     final searchQuery = '%${query.toLowerCase()}%';
//
//     final whereConditions = <String>[
//       '${DatabaseConstants.columnDeletedAt} IS NULL',
//       '(LOWER(${DatabaseConstants.columnTaskTitle}) LIKE ? OR LOWER(${DatabaseConstants.columnTaskDescription}) LIKE ?)',
//     ];
//     final whereArgs = <dynamic>[searchQuery, searchQuery];
//
//     if (projectId != null) {
//       whereConditions.add('${DatabaseConstants.columnTaskProjectId} = ?');
//       whereArgs.add(projectId);
//     }
//
//     final results = await _databaseHelper.query(
//       DatabaseConstants.tasksTable,
//       where: whereConditions.join(' AND '),
//       whereArgs: whereArgs,
//       orderBy: '${DatabaseConstants.columnUpdatedAt} DESC',
//       limit: validPageSize,
//       offset: offset,
//     );
//
//     return results.map((map) => TaskModel.fromMap(map)).toList();
//   }
//
//   @override
//   Future<TaskModel> updateTask(TaskModel task) async {
//     final updatedTask = task.copyWith(
//       updatedAt: DateTime.now(),
//       syncStatus: SyncStatus.pending,
//     );
//
//     await _databaseHelper.update(
//       DatabaseConstants.tasksTable,
//       updatedTask.toMap(),
//       where: '${DatabaseConstants.columnId} = ?',
//       whereArgs: [task.id],
//     );
//
//     return updatedTask;
//   }
//
//   @override
//   Future<void> deleteTask(String id, {bool softDelete = true}) async {
//     if (softDelete) {
//       final now = DateTime.now();
//       await _databaseHelper.update(
//         DatabaseConstants.tasksTable,
//         {
//           DatabaseConstants.columnDeletedAt: now.toIso8601String(),
//           DatabaseConstants.columnUpdatedAt: now.toIso8601String(),
//           DatabaseConstants.columnSyncStatus: SyncStatus.pending.name,
//         },
//         where: '${DatabaseConstants.columnId} = ?',
//         whereArgs: [id],
//       );
//     } else {
//       await hardDeleteTask(id);
//     }
//   }
//
//   @override
//   Future<void> hardDeleteTask(String id) async {
//     await _databaseHelper.delete(
//       DatabaseConstants.tasksTable,
//       where: '${DatabaseConstants.columnId} = ?',
//       whereArgs: [id],
//     );
//   }
//
//   @override
//   Future<List<TaskModel>> getUnsyncedTasks() async {
//     final results = await _databaseHelper.query(
//       DatabaseConstants.tasksTable,
//       where: '${DatabaseConstants.columnSyncStatus} != ?',
//       whereArgs: [SyncStatus.synced.name],
//       orderBy: '${DatabaseConstants.columnUpdatedAt} ASC',
//     );
//
//     return results.map((map) => TaskModel.fromMap(map)).toList();
//   }
//
//   @override
//   Future<TaskModel?> getTaskByServerId(String serverId) async {
//     final results = await _databaseHelper.query(
//       DatabaseConstants.tasksTable,
//       where: '${DatabaseConstants.columnServerId} = ?',
//       whereArgs: [serverId],
//     );
//
//     if (results.isEmpty) return null;
//     return TaskModel.fromMap(results.first);
//   }
//
//   @override
//   Future<int> getTasksCount({
//     String? projectId,
//     TaskStatus? status,
//     bool includeDeleted = false,
//   }) async {
//     final whereConditions = <String>[];
//     final whereArgs = <dynamic>[];
//
//     if (!includeDeleted) {
//       whereConditions.add('${DatabaseConstants.columnDeletedAt} IS NULL');
//     }
//
//     if (projectId != null) {
//       whereConditions.add('${DatabaseConstants.columnTaskProjectId} = ?');
//       whereArgs.add(projectId);
//     }
//
//     if (status != null) {
//       whereConditions.add('${DatabaseConstants.columnTaskStatus} = ?');
//       whereArgs.add(status.name);
//     }
//
//     final whereClause =
//         whereConditions.isEmpty
//             ? ''
//             : ' WHERE ${whereConditions.join(' AND ')}';
//
//     final result = await _databaseHelper.rawQuery(
//       'SELECT COUNT(*) as count FROM ${DatabaseConstants.tasksTable}$whereClause',
//       whereArgs.isEmpty ? null : whereArgs,
//     );
//
//     return result.first['count'] as int;
//   }
//
//   @override
//   Future<List<TaskModel>> getOverdueTasks() async {
//     final now = DateTime.now().toIso8601String();
//
//     final results = await _databaseHelper.query(
//       DatabaseConstants.tasksTable,
//       where: '''
//         ${DatabaseConstants.columnDeletedAt} IS NULL AND
//         ${DatabaseConstants.columnTaskStatus} = ? AND
//         ${DatabaseConstants.columnTaskDueDate} IS NOT NULL AND
//         ${DatabaseConstants.columnTaskDueDate} < ?
//       ''',
//       whereArgs: [TaskStatus.pending.name, now],
//       orderBy: '${DatabaseConstants.columnTaskDueDate} ASC',
//     );
//
//     return results.map((map) => TaskModel.fromMap(map)).toList();
//   }
//
//   @override
//   Future<TaskModel> toggleTaskStatus(String id) async {
//     final task = await getTask(id);
//     if (task == null) {
//       throw Exception('Task not found');
//     }
//
//     final updatedTask =
//         task.isCompleted ? task.markAsIncomplete() : task.markAsCompleted();
//
//     var updatedTaskModel = await updateTask(TaskModel.fromEntity(updatedTask));
//
//     return updatedTaskModel;
//   }
// }
