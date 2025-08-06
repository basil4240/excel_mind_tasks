// import '../../core/enums/sync_status.dart';
// import '../../core/enums/task_status.dart';
// import '../../domain/entities/task.dart';
// import '../../domain/repositories/task_repository.dart';
// import '../datasources/local/task_local_data_source.dart';
// import '../models/task_model.dart';
//
// class TaskRepositoryImpl implements TaskRepository {
//   final TaskLocalDataSource localDataSource;
//
//   TaskRepositoryImpl(this.localDataSource);
//
//   @override
//   Future<String> createTask(Task task) {
//     // TODO: implement createTask
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> deleteTask(String id) {
//     // TODO: implement deleteTask
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<int> getSearchTasksCount(String query) {
//     // TODO: implement getSearchTasksCount
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<Task?> getTaskById(String id) {
//     // TODO: implement getTaskById
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<List<Task>> getTasks({int limit = 20, int offset = 0}) {
//     // TODO: implement getTasks
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<int> getTasksByProjectCount(String projectId) {
//     // TODO: implement getTasksByProjectCount
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<List<Task>> getTasksByProjectId(String projectId, {int limit = 20, int offset = 0}) {
//     // TODO: implement getTasksByProjectId
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<int> getTasksCount() {
//     // TODO: implement getTasksCount
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<List<Task>> searchTasks(String query, {int limit = 20, int offset = 0}) {
//     // TODO: implement searchTasks
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> toggleTaskStatus(String id, TaskStatus status) {
//     // TODO: implement toggleTaskStatus
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> updateTask(Task task) {
//     // TODO: implement updateTask
//     throw UnimplementedError();
//   }
//
//
// }