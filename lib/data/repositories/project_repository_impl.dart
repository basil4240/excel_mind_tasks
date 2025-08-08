import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/paginated_result.dart';
import '../../domain/entities/project.dart';
import '../../domain/repositories/project_repository.dart';
import '../datasources/local/project_local_data_source.dart';
import '../models/project_model.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectLocalDataSource localDataSource;

  ProjectRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, Project>> create(Project project) async {
    try {
      final projectModel = ProjectModel.fromEntity(project);
      final result = await localDataSource.create(projectModel);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to create project'));
    }
  }

  @override
  Future<Either<Failure, Project?>> getById(int id) async {
    try {
      final result = await localDataSource.getById(id);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to get project'));
    }
  }

  @override
  Future<Either<Failure, PaginatedResult<Project>>> getAll({int page = 1, int pageSize = 10}) async {
    try {
      final result = await localDataSource.getAll(page: page, pageSize: pageSize);
      final projects = PaginatedResult<Project>(
        items: result.items.cast<Project>(),
        page: result.page,
        pageSize: result.pageSize,
        totalCount: result.totalCount,
      );
      return Right(projects);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to get projects'));
    }
  }

  @override
  Future<Either<Failure, PaginatedResult<Project>>> search(String query, {int page = 1, int pageSize = 10}) async {
    try {
      final result = await localDataSource.search(query, page: page, pageSize: pageSize);
      final projects = PaginatedResult<Project>(
        items: result.items.cast<Project>(),
        page: result.page,
        pageSize: result.pageSize,
        totalCount: result.totalCount,
      );
      return Right(projects);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to search projects'));
    }
  }

  @override
  Future<Either<Failure, Project>> update(Project project) async {
    try {
      final projectModel = ProjectModel.fromEntity(project);
      final result = await localDataSource.update(projectModel);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to update project'));
    }
  }

  @override
  Future<Either<Failure, void>> delete(int id) async {
    try {
      await localDataSource.delete(id);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to delete project'));
    }
  }

  @override
  Future<Either<Failure, Project>> updateProjectStats(int projectId) async {
    try {
      final result = await localDataSource.updateProjectStats(projectId);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to update project stats'));
    }
  }

}
