import '../../domain/entities/project.dart';

class ProjectModel extends Project {
  ProjectModel({
    super.id,
    required super.name,
    super.description,
    super.color,
    super.startedAt,
    super.endedAt,
    super.tasksCount = 0,
    super.completedTasks = 0,
    super.progress = 0.0,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      color: map['color'],
      startedAt: map['startedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['startedAt']) : null,
      endedAt: map['endedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['endedAt']) : null,
      tasksCount: map['tasksCount'] ?? 0,
      completedTasks: map['completedTasks'] ?? 0,
      progress: (map['progress'] ?? 0.0).toDouble(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color': color,
      'startedAt': startedAt?.millisecondsSinceEpoch,
      'endedAt': endedAt?.millisecondsSinceEpoch,
      'tasksCount': tasksCount,
      'completedTasks': completedTasks,
      'progress': progress,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory ProjectModel.fromEntity(Project project) {
    return ProjectModel(
      id: project.id,
      name: project.name,
      description: project.description,
      color: project.color,
      startedAt: project.startedAt,
      endedAt: project.endedAt,
      tasksCount: project.tasksCount,
      completedTasks: project.completedTasks,
      progress: project.progress,
      createdAt: project.createdAt,
      updatedAt: project.updatedAt,
    );
  }
}
