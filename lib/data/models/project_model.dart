import '../../core/constants/database_constants.dart';
import '../../core/enums/sync_status.dart';
import '../../core/utils/date_utils.dart' as app_date_utils;
import '../../domain/entities/project.dart';

class ProjectModel extends Project {
  const ProjectModel({
    required super.id,
    super.serverId,
    required super.name,
    super.description,
    super.color,
    super.syncStatus,
    required super.createdAt,
    required super.updatedAt,
    super.deletedAt,
    super.lastSyncAt, required super.startedAt,
    required super.endedAt,
  });

  // Convert from Entity to Model
  factory ProjectModel.fromEntity(Project project) {
    return ProjectModel(
      id: project.id,
      endedAt: project.endedAt,
      serverId: project.serverId,
      name: project.name,
      description: project.description,
      color: project.color,
      syncStatus: project.syncStatus,
      createdAt: project.createdAt,
      updatedAt: project.updatedAt,
      deletedAt: project.deletedAt,
      lastSyncAt: project.lastSyncAt, startedAt: project.startedAt,
    );
  }

  // Convert from database map
  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: map[DatabaseConstants.columnId] as int,
      serverId: map[DatabaseConstants.columnServerId] as int?,
      name: map[DatabaseConstants.columnProjectName] as String,
      description: map[DatabaseConstants.columnProjectDescription] as String?,
      color: map[DatabaseConstants.columnProjectColor] as String?,
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
      ), startedAt: app_date_utils.DateUtils.fromIsoString(
        map[DatabaseConstants.startedAt] as String,

    )!, endedAt: app_date_utils.DateUtils.fromIsoString(
      map[DatabaseConstants.endedAt] as String,
    )!,
    );
  }

  // Convert to database map
  Map<String, dynamic> toMap() {
    return {
      DatabaseConstants.columnId: id,
      DatabaseConstants.columnServerId: serverId,
      DatabaseConstants.columnProjectName: name,
      DatabaseConstants.columnProjectDescription: description,
      DatabaseConstants.columnProjectColor: color,
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
      'name': name,
      'description': description,
      'color': color,
      'created_at': app_date_utils.DateUtils.toIsoString(createdAt),
      'updated_at': app_date_utils.DateUtils.toIsoString(updatedAt),
      if (deletedAt != null)
        'deleted_at': app_date_utils.DateUtils.toIsoString(deletedAt!),
    };
  }

  // Convert from API JSON
  factory ProjectModel.fromJson(Map<String, dynamic> json, int localId) {
    return ProjectModel(
      id: localId, // Local ID remains the same
      serverId: json['id'] as int?, // Server ID
      name: json['name'] as String,
      description: json['description'] as String?,
      color: json['color'] as String?,
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
      startedAt: app_date_utils.DateUtils.fromIsoString(
      json['started_at'] as String?,
    )!, endedAt: app_date_utils.DateUtils.fromIsoString(
      json['ended_at'] as String?,
    )!,
    );
  }
}
