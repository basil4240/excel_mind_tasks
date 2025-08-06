import '../../../core/types.dart';
import '../../repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repository;

  GetTasks(this.repository);

  Future<TasksResult> call({int limit = 20, int offset = 0, required int projectId}) async {
    final tasks = await repository.getTasks(limit: limit, offset: offset, projectId: projectId);
    final totalCount = await repository.getTasksByProjectCount(projectId);

    return (
      tasks: tasks,
      totalCount: totalCount,
      offset: offset,
      limit: limit,
    );
  }
}
