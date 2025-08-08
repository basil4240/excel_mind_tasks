import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../repositories/task_repository.dart';

class DeleteTaskUseCase {
  final TaskRepository repository;

  DeleteTaskUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.delete(id);
  }
}