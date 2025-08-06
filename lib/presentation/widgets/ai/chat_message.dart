import 'package:excel_mind_tasks/presentation/widgets/ai/suggested_task.dart';

class ChatMessage {
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final List<SuggestedTask>? suggestedTasks;

  ChatMessage({
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.suggestedTasks,
  });
}