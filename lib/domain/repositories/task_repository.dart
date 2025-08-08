import 'package:dartz/dartz.dart' hide Task;
import '../../core/errors/failures.dart';
import '../../core/utils/paginated_result.dart';
import '../entities/task.dart';

abstract class TaskRepository {
  Future<Either<Failure, Task>> create(Task task);
  Future<Either<Failure, Task?>> getById(int id);
  Future<Either<Failure, PaginatedResult<Task>>> getAll({int page = 1, int pageSize = 10});
  Future<Either<Failure, PaginatedResult<Task>>> search(String query, {int page = 1, int pageSize = 10});
  Future<Either<Failure, Task>> update(Task task);
  Future<Either<Failure, void>> delete(int id);
}