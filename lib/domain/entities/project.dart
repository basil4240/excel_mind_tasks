class Project {
  final int? id;
  final String name;
  final String? description;
  final String? color;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final int tasksCount;
  final int completedTasks;
  final double progress;
  final DateTime createdAt;
  final DateTime updatedAt;

  Project({
    this.id,
    required this.name,
    this.description,
    this.color,
    this.startedAt,
    this.endedAt,
    this.tasksCount = 0,
    this.completedTasks = 0,
    this.progress = 0.0,
    required this.createdAt,
    required this.updatedAt,
  });
}