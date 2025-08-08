import 'package:dartz/dartz.dart' hide Task;

import '../../../core/errors/failures.dart';
import '../../entities/task.dart';
import '../../repositories/task_repository.dart';

class UpdateTaskUseCase {
  final TaskRepository repository;

  UpdateTaskUseCase(this.repository);

  Future<Either<Failure, Task>> call(Task task) async {
    return await repository.update(task);
  }
}