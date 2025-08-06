enum ProjectStatus {
  active('Active'),
  onHold('On Hold'),
  completed('Completed');

  const ProjectStatus(this.displayName);
  final String displayName;

  static ProjectStatus fromString(String value) {
    return ProjectStatus.values.firstWhere(
          (status) => status.name == value.toLowerCase(),
      orElse: () => ProjectStatus.active,
    );
  }
}
