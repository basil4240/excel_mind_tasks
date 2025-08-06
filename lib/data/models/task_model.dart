import '../../core/constants/database_constants.dart';
import '../../core/enums/priority.dart';
import '../../core/enums/sync_status.dart';
import '../../core/enums/task_status.dart';
import '../../core/utils/date_utils.dart' as app_date_utils;
import '../../domain/entities/task.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    super.serverId,
    required super.title,
    super.description,
    super.status,
    super.priority,
    required super.dueDate,
    required super.projectId,
    super.completedAt,
    super.syncStatus,
    required super.createdAt,
    required super.updatedAt,
    super.deletedAt,
    super.lastSyncAt,
  });

  // Convert from Entity to Model
  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      serverId: task.serverId,
      title: task.title,
      description: task.description,
      status: task.status,
      priority: task.priority,
      dueDate: task.dueDate,
      projectId: task.projectId,
      completedAt: task.completedAt,
      syncStatus: task.syncStatus,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
      deletedAt: task.deletedAt,
      lastSyncAt: task.lastSyncAt,
    );
  }

  // Convert from database map
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map[DatabaseConstants.columnId] as int,
      serverId: map[DatabaseConstants.columnServerId] as int?,
      title: map[DatabaseConstants.columnTaskTitle] as String,
      description: map[DatabaseConstants.columnTaskDescription] as String?,
      status: TaskStatus.fromString(
        map[DatabaseConstants.columnTaskStatus] as String? ?? 'pending',
      ),
      priority: Priority.fromString(
        map[DatabaseConstants.columnTaskPriority] as String? ?? 'medium',
      ),
      dueDate: app_date_utils.DateUtils.fromIsoString(
        map[DatabaseConstants.columnTaskDueDate] as String?,
      )!,
      projectId: map[DatabaseConstants.columnTaskProjectId] as int,
      completedAt: app_date_utils.DateUtils.fromIsoString(
        map[DatabaseConstants.columnTaskCompletedAt] as String?,
      ),
      syncStatus: SyncStatus.fromString(
        map[DatabaseConstants.columnSyncStatus] as String? ?? 'pending',
      ),
      createdAt: app_date_utils.DateUtils.fromIsoString(
        map[DatabaseConstants.columnCreatedAt] as String,
      )!,
      updatedAt: app_date_utils.DateUtils.fromIsoString(
        map[DatabaseConstants.columnUpdatedAt] as String,
      )!,
      deletedAt: app_date_utils.DateUtils.fromIsoString(
        map[DatabaseConstants.columnDeletedAt] as String?,
      ),
      lastSyncAt: app_date_utils.DateUtils.fromIsoString(
        map[DatabaseConstants.columnLastSyncAt] as String?,
      ),
    );
  }

  // Convert to database map
  Map<String, dynamic> toMap() {
    return {
      DatabaseConstants.columnId: id,
      DatabaseConstants.columnServerId: serverId,
      DatabaseConstants.columnTaskTitle: title,
      DatabaseConstants.columnTaskDescription: description,
      DatabaseConstants.columnTaskStatus: status.name,
      DatabaseConstants.columnTaskPriority: priority.name,
      DatabaseConstants.columnTaskDueDate: app_date_utils.DateUtils.toIsoString(dueDate),
      DatabaseConstants.columnTaskProjectId: projectId,
      DatabaseConstants.columnTaskCompletedAt: completedAt != null
          ? app_date_utils.DateUtils.toIsoString(completedAt!)
          : null,
      DatabaseConstants.columnSyncStatus: syncStatus.name,
      DatabaseConstants.columnCreatedAt: app_date_utils.DateUtils.toIsoString(createdAt),
      DatabaseConstants.columnUpdatedAt: app_date_utils.DateUtils.toIsoString(updatedAt),
      DatabaseConstants.columnDeletedAt: deletedAt != null
          ? app_date_utils.DateUtils.toIsoString(deletedAt!)
          : null,
      DatabaseConstants.columnLastSyncAt: lastSyncAt != null
          ? app_date_utils.DateUtils.toIsoString(lastSyncAt!)
          : null,
    };
  }

  // Convert to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'id': serverId ?? id, // Use serverId for API if available
      'title': title,
      'description': description,
      'status': status.name,
      'priority': priority.name,
      'due_date': app_date_utils.DateUtils.toIsoString(dueDate),
      'project_id': projectId, // This might need to be server project ID
      'completed_at': completedAt != null
          ? app_date_utils.DateUtils.toIsoString(completedAt!)
          : null,
      'created_at': app_date_utils.DateUtils.toIsoString(createdAt),
      'updated_at': app_date_utils.DateUtils.toIsoString(updatedAt),
      if (deletedAt != null)
        'deleted_at': app_date_utils.DateUtils.toIsoString(deletedAt!),
    };
  }

  // Convert from API JSON
  factory TaskModel.fromJson(Map<String, dynamic> json, int localId, int localProjectId) {
    return TaskModel(
      id: localId, // Local ID remains the same
      serverId: json['id'] as int?, // Server ID
      title: json['title'] as String,
      description: json['description'] as String?,
      status: TaskStatus.fromString(json['status'] as String? ?? 'pending'),
      priority: Priority.fromString(json['priority'] as String? ?? 'medium'),
      dueDate: app_date_utils.DateUtils.fromIsoString(
        json['due_date'] as String?,
      )!,
      projectId: localProjectId, // Local project ID
      completedAt: app_date_utils.DateUtils.fromIsoString(
        json['completed_at'] as String?,
      ),
      syncStatus: SyncStatus.synced, // Assume synced when from server
      createdAt: app_date_utils.DateUtils.fromIsoString(
        json['created_at'] as String,
      )!,
      updatedAt: app_date_utils.DateUtils.fromIsoString(
        json['updated_at'] as String,
      )!,
      deletedAt: app_date_utils.DateUtils.fromIsoString(
        json['deleted_at'] as String?,
      ),
      lastSyncAt: DateTime.now(),
    );
  }


}