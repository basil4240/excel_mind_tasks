import 'package:dartz/dartz.dart' hide Task;
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/paginated_result.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/local/task_local_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, Task>> create(Task task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      final result = await localDataSource.create(taskModel);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to create task'));
    }
  }

  @override
  Future<Either<Failure, Task?>> getById(int id) async {
    try {
      final result = await localDataSource.getById(id);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to get task'));
    }
  }

  @override
  Future<Either<Failure, PaginatedResult<Task>>> getAll({int page = 1, int pageSize = 10}) async {
    try {
      final result = await localDataSource.getAll(page: page, pageSize: pageSize);
      final tasks = PaginatedResult<Task>(
        items: result.items.cast<Task>(),
        page: result.page,
        pageSize: result.pageSize,
        totalCount: result.totalCount,
      );
      return Right(tasks);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to get tasks'));
    }
  }

  @override
  Future<Either<Failure, PaginatedResult<Task>>> search(String query, {int page = 1, int pageSize = 10}) async {
    try {
      final result = await localDataSource.search(query, page: page, pageSize: pageSize);
      final tasks = PaginatedResult<Task>(
        items: result.items.cast<Task>(),
        page: result.page,
        pageSize: result.pageSize,
        totalCount: result.totalCount,
      );
      return Right(tasks);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to search tasks'));
    }
  }

  @override
  Future<Either<Failure, Task>> update(Task task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      final result = await localDataSource.update(taskModel);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to update task'));
    }
  }

  @override
  Future<Either<Failure, void>> delete(int id) async {
    try {
      await localDataSource.delete(id);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to delete task'));
    }
  }
}