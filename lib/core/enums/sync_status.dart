enum SyncStatus {
  synced,
  pending,
  failed,
  deleted; // For soft deletes

  static SyncStatus fromString(String value) {
    return SyncStatus.values.firstWhere(
          (status) => status.name == value.toLowerCase(),
      orElse: () => SyncStatus.pending,
    );
  }
}