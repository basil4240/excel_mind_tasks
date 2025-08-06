import '../../core/enums/project_status.dart';
import '../../core/enums/sync_status.dart';

class Project  {
  final int id;
  final int? serverId;
  final String name;
  final String? description;
  final String? color;
  final SyncStatus syncStatus;
  final ProjectStatus status;
  final DateTime startedAt;
  final DateTime endedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime? lastSyncAt;

  const Project({
    required this.id,
    this.serverId,
    required this.name,
    this.description,
    this.color,
    this.status = ProjectStatus.active,
    this.syncStatus = SyncStatus.pending,
    required this.startedAt,
    required this.endedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.lastSyncAt,
  });


}