import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/paginated_result.dart';
import '../entities/project.dart';

abstract class ProjectRepository {
  Future<Either<Failure, Project>> create(Project project);
  Future<Either<Failure, Project?>> getById(int id);
  Future<Either<Failure, PaginatedResult<Project>>> getAll({int page = 1, int pageSize = 10});
  Future<Either<Failure, PaginatedResult<Project>>> search(String query, {int page = 1, int pageSize = 10});
  Future<Either<Failure, Project>> update(Project project);
  Future<Either<Failure, void>> delete(int id);
  Future<Either<Failure, Project>> updateProjectStats(int projectId);

}