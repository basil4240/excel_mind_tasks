import 'package:equatable/equatable.dart';
import '../../core/enums/priority.dart';
import '../../core/enums/sync_status.dart';
import '../../core/enums/task_status.dart';

class Task {
  final int id;
  final int? serverId;
  final String title;
  final String? description;
  final TaskStatus status;
  final Priority priority;
  final DateTime dueDate;
  final int projectId;
  final DateTime? completedAt;
  final SyncStatus syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime? lastSyncAt;

  const Task({
    required this.id,
    this.serverId,
    required this.title,
    this.description,
    this.status = TaskStatus.pending,
    this.priority = Priority.medium,
    required this.dueDate,
    required this.projectId,
    this.completedAt,
    this.syncStatus = SyncStatus.pending,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.lastSyncAt,
  });

}