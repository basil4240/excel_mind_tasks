class DatabaseConstants {
  static const String databaseName = 'todo_app.db';
  static const int databaseVersion = 1;

  // Table names
  static const String projectsTable = 'projects';
  static const String tasksTable = 'tasks';

  // Common columns
  static const String columnId = 'id';
  static const String columnServerId = 'server_id';
  static const String columnSyncStatus = 'sync_status';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';
  static const String startedAt = 'started_at';
  static const String endedAt = 'ended_at';
  static const String columnDeletedAt = 'deleted_at';
  static const String columnLastSyncAt = 'last_sync_at';

  // Projects table columns
  static const String columnProjectName = 'name';
  static const String columnProjectDescription = 'description';
  static const String columnProjectColor = 'color';

  // Tasks table columns
  static const String columnTaskTitle = 'title';
  static const String columnTaskDescription = 'description';
  static const String columnTaskStatus = 'status';
  static const String columnTaskPriority = 'priority';
  static const String columnTaskDueDate = 'due_date';
  static const String columnTaskProjectId = 'project_id';
  static const String columnTaskCompletedAt = 'completed_at';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Sync constants
  static const int maxSyncRetries = 3;
  static const Duration syncBatchDelay = Duration(milliseconds: 500);
}