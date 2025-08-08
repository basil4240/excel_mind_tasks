// enum Priority {
//   low('Low'),
//   medium('Medium'),
//   high('High');
//
//   const Priority(this.displayName);
//   final String displayName;
//
//   static Priority fromString(String value) {
//     return Priority.values.firstWhere(
//           (priority) => priority.name == value.toLowerCase(),
//       orElse: () => Priority.medium,
//     );
//   }
// }
enum TaskPriority { low, medium, high }