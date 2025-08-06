import 'package:dartz/dartz.dart' hide Task;

import '../../core/errors/failures.dart';
import '../../core/types.dart';
import '../entities/task.dart';

abstract class TaskRepository {
  Future<Either<Failure, Task>> createTask(CreateTaskData createTaskData);

  Future<Either<Failure, Task>> updateTask(UpdateTaskData updateTaskData, int id);

  Future<Either<Failure, void>> deleteTask(int id);

  Future<Either<Failure, Task?>> getTaskById(int id);

  Future<Either<Failure, List<Task>>> getTasks({
    int limit = 20,
    int offset = 0,
    required int projectId,
  });

  Future<Either<Failure, List<Task>>> getTasksByProjectId(
    int projectId, {
    int limit = 20,
    int offset = 0,
  });

  Future<Either<Failure, List<Task>>> searchTasks(
    String query, {
    int limit = 20,
    int offset = 0,
  });

  Future<Either<Failure, int>> getTasksCount();

  Future<Either<Failure, int>> getTasksByProjectCount(int projectId);

  Future<Either<Failure, int>> getSearchTasksCount(String query);

  Future<Either<Failure, int>> getTodayTasksCount();

  Future<Either<Failure, int>> getCompletedTasksCount();

  Future<Either<Failure, int>> getOverdueTasksCount();
}
