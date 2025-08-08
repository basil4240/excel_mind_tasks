import '../../core/enums/priority.dart';
import '../../core/enums/task_status.dart';

class Task {
  final int? id;
  final String title;
  final String? description;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime? dueDate;
  final int? projectId;
  final String? projectName;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    this.id,
    required this.title,
    this.projectName,
    this.description,
    this.status = TaskStatus.incomplete,
    this.priority = TaskPriority.low,
    this.dueDate,
    this.projectId,
    required this.createdAt,
    required this.updatedAt,
  });
}