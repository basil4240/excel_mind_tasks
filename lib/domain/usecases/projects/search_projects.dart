import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../../core/utils/paginated_result.dart';
import '../../entities/project.dart';
import '../../repositories/project_repository.dart';

class SearchProjectsUseCase {
  final ProjectRepository repository;

  SearchProjectsUseCase(this.repository);

  Future<Either<Failure, PaginatedResult<Project>>> call(String query, {int page = 1, int pageSize = 10}) async {
    return await repository.search(query, page: page, pageSize: pageSize);
  }
}
