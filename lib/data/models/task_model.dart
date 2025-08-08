import '../../core/enums/priority.dart';
import '../../core/enums/task_status.dart';
import '../../domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel({
    super.id,
    required super.title,
    super.description,
    super.status = TaskStatus.incomplete,
    super.priority = TaskPriority.low,
    super.dueDate,
    super.projectId,
    super.projectName,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      status: TaskStatus.values.firstWhere((e) => e.name == map['status']),
      priority: TaskPriority.values.firstWhere((e) => e.name == map['priority']),
      dueDate: map['dueDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['dueDate']) : null,
      projectId: map['projectId'],
      projectName: map['projectName'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.name,
      'priority': priority.name,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'projectId': projectId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      status: task.status,
      priority: task.priority,
      dueDate: task.dueDate,
      projectId: task.projectId,
      projectName: task.projectName,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
    );
  }
}