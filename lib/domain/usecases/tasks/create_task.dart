import 'package:dartz/dartz.dart' hide Task;

import '../../../core/errors/failures.dart';
import '../../../core/types.dart';
import '../../entities/task.dart';
import '../../repositories/task_repository.dart';

class CreateTask {
  final TaskRepository repository;

  CreateTask(this.repository);

  Future<Either<Failure, Task>> call(CreateTaskData createTaskData) async {
    return await repository.createTask(createTaskData);
  }
}
