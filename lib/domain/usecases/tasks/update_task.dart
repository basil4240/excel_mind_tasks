import 'package:dartz/dartz.dart' hide Task;
import 'package:excel_mind_tasks/core/types.dart';

import '../../../core/errors/failures.dart';
import '../../entities/task.dart';
import '../../repositories/task_repository.dart';

class UpdateTask {
  final TaskRepository repository;

  UpdateTask(this.repository);

  Future<Either<Failure, Task>> call(UpdateTaskData updateTaskData, int id) async {
    return await repository.updateTask(updateTaskData, id);
  }
}