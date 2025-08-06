import '../../../core/types.dart';
import '../../entities/task.dart';
import '../../repositories/task_repository.dart';

class SearchTasks {
  final TaskRepository repository;

  SearchTasks(this.repository);

  Future<TasksResult> call(String query,
      {int limit = 20,
        int offset = 0,}) async {

    final tasks = await repository.searchTasks(
        query, limit: limit,
      offset: offset,);

    final totalCount = await repository.getSearchTasksCount(query);

    return (
      tasks: tasks,
    totalCount: totalCount,
    offset: offset,
    limit: limit,
    );
  }
}