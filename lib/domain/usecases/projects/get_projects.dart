import '../../../core/types.dart';
import '../../repositories/project_repository.dart';

class GetProjects {
  final ProjectRepository repository;

  GetProjects(this.repository);

  Future<ProjectsResult> call({int limit = 20, int offset = 0}) async {
    final projects = await repository.getProjects(limit: limit, offset: offset);
    final totalCount = await repository.getProjectsCount();

    return (
      projects: projects,
      totalCount: totalCount,
      offset: offset,
      limit: limit,
    );
  }
}
