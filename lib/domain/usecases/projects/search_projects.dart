import '../../../core/types.dart';
import '../../repositories/project_repository.dart';

class SearchProjects {
  final ProjectRepository repository;

  SearchProjects(this.repository);

  Future<ProjectsResult> call(
    String query, {
    int limit = 20,
    int offset = 0,
  }) async {
    final projects = await repository.searchProjects(
      query,
      limit: limit,
      offset: offset,
    );
    final totalCount = await repository.getSearchProjectsCount(query);

    return (
      projects: projects,
      totalCount: totalCount,
      offset: offset,
      limit: limit,
    );
  }
}
