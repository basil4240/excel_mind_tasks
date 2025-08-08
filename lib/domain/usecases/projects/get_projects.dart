import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../../core/utils/paginated_result.dart';
import '../../entities/project.dart';
import '../../repositories/project_repository.dart';

class GetProjectsUseCase {
  final ProjectRepository repository;

  GetProjectsUseCase(this.repository);

  Future<Either<Failure, PaginatedResult<Project>>> call({int page = 1, int pageSize = 10}) async {
    return await repository.getAll(page: page, pageSize: pageSize);
  }
}
