// enum TaskStatus {
//   pending('Pending'),
//   completed('Completed');
//
//   const TaskStatus(this.displayName);
//   final String displayName;
//
//   static TaskStatus fromString(String value) {
//     return TaskStatus.values.firstWhere(
//           (status) => status.name == value.toLowerCase(),
//       orElse: () => TaskStatus.pending,
//     );
//   }
// }
enum TaskStatus { complete, incomplete }
