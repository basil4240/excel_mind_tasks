
import 'package:dartz/dartz.dart' hide Task;

import '../../../core/errors/failures.dart';
import '../../../core/utils/paginated_result.dart';
import '../../entities/task.dart';
import '../../repositories/task_repository.dart';

class SearchTasksUseCase {
  final TaskRepository repository;

  SearchTasksUseCase(this.repository);

  Future<Either<Failure, PaginatedResult<Task>>> call(String query, {int page = 1, int pageSize = 10}) async {
    return await repository.search(query, page: page, pageSize: pageSize);
  }
}