import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/types.dart';
import '../entities/project.dart';

abstract class ProjectRepository {
  Future<Either<Failure, Project>> createProject(
    CreateProjectData createProjectData,
  );

  Future<Either<Failure, Project>> updateProject(
    UpdateProjectData updateProjectData,
  );

  Future<Either<Failure, void>> deleteProject(int id);

  Future<Either<Failure, Project?>> getProjectById(int id);

  Future<Either<Failure, List<Project>>> getProjects({
    int limit = 20,
    int offset = 0,
  });

  Future<Either<Failure, List<Project>>> searchProjects(
    String query, {
    int limit = 20,
    int offset = 0,
  });

  Future<Either<Failure, int>> getProjectsCount();

  Future<Either<Failure, int>> getSearchProjectsCount(String query);
}
