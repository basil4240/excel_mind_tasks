import 'package:dartz/dartz.dart' hide Task;

import '../../../core/errors/failures.dart';
import '../../../core/types.dart';
import '../../entities/task.dart';
import '../../repositories/task_repository.dart';

class CreateTaskUseCase {
  final TaskRepository repository;

  CreateTaskUseCase(this.repository);

  Future<Either<Failure, Task>> call(Task task) async {
    return await repository.create(task);
  }
}
