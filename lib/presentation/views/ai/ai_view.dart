import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/styles/app_box_shadows.dart';
import '../../theme/styles/app_input_decorations.dart';
import '../../theme/styles/app_text_styles.dart';
import '../../widgets/ai/chat_message.dart';
import '../../widgets/ai/suggested_task.dart';

class AIAssistantView extends StatefulWidget {
  const AIAssistantView({super.key});

  @override
  State<AIAssistantView> createState() => _AIAssistantViewState();
}
class _AIAssistantViewState extends State<AIAssistantView> {
  final _promptController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoading = false;
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  void _initializeChat() {
    _messages.add(ChatMessage(
      message: "Hi! I'm your AI assistant. I can help you:\n\n• Plan your tasks and projects\n• Suggest better schedules\n• Create task lists from descriptions\n• Organize your workflow\n\nWhat would you like me to help you with today?",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyles = Theme.of(context).extension<AppTextStyles>()!;
    final inputDecorations = Theme.of(context).extension<AppInputDecorations>()!;

    return Scaffold(
      backgroundColor: colors.backgroundColor,
      appBar: AppBar(
        backgroundColor: colors.backgroundColor,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: colors.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome,
                color: colors.primaryColor,
                size: 20.w,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'AI Assistant',
              style: textStyles.headingMedium,
            ),
          ],
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert, color: colors.iconColor),
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () {
                  // TODO: Clear chat history
                  _clearChat();
                },
                child: Text('Clear Chat'),
              ),
              PopupMenuItem(
                onTap: () {
                  // TODO: Show AI settings
                },
                child: Text('AI Settings'),
              ),
              PopupMenuItem(
                onTap: () {
                  // TODO: Show help/examples
                },
                child: Text('Examples'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Actions
          _buildQuickActions(context),

          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(context, _messages[index]);
              },
            ),
          ),

          // Loading Indicator
          if (_isLoading) _buildLoadingIndicator(context),

          // Input Area
          _buildInputArea(context),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyles = Theme.of(context).extension<AppTextStyles>()!;

    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildQuickActionChip(
            context,
            'Plan my week',
            Icons.calendar_month,
                () => _sendQuickPrompt('Plan my week with 3 work tasks and 2 wellness tasks'),
          ),
          SizedBox(width: 8.w),
          _buildQuickActionChip(
            context,
            'Morning routine',
            Icons.wb_sunny,
                () => _sendQuickPrompt('Create a productive morning routine with 5 tasks'),
          ),
          SizedBox(width: 8.w),
          _buildQuickActionChip(
            context,
            'Project planning',
            Icons.assignment,
                () => _sendQuickPrompt('Help me plan a mobile app development project'),
          ),
          SizedBox(width: 8.w),
          _buildQuickActionChip(
            context,
            'Time blocking',
            Icons.schedule,
                () => _sendQuickPrompt('Suggest a time blocking schedule for today'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionChip(
      BuildContext context,
      String label,
      IconData icon,
      VoidCallback onTap,
      ) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyles = Theme.of(context).extension<AppTextStyles>()!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: colors.surfaceColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: colors.borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.w,
              color: colors.primaryColor,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: textStyles.labelSmall.copyWith(
                color: colors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessage message) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyles = Theme.of(context).extension<AppTextStyles>()!;
    final shadows = Theme.of(context).extension<AppBoxShadows>()!;

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: colors.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome,
                color: colors.primaryColor,
                size: 16.w,
              ),
            ),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: message.isUser ? colors.primaryColor : colors.cardColor,
                    borderRadius: BorderRadius.circular(16.r).copyWith(
                      bottomRight: message.isUser ? Radius.circular(4.r) : Radius.circular(16.r),
                      bottomLeft: message.isUser ? Radius.circular(16.r) : Radius.circular(4.r),
                    ),
                    boxShadow: shadows.cardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.message,
                        style: textStyles.bodyMedium.copyWith(
                          color: message.isUser ? colors.backgroundColor : colors.textColor,
                        ),
                      ),
                      if (message.suggestedTasks != null && message.suggestedTasks!.isNotEmpty) ...[
                        SizedBox(height: 12.h),
                        _buildSuggestedTasks(context, message.suggestedTasks!),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _formatTime(message.timestamp),
                  style: textStyles.captionSmall.copyWith(
                    color: colors.subtitleColor,
                  ),
                ),
              ],
            ),
          ),
          if (message.isUser) ...[
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: colors.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                color: colors.primaryColor,
                size: 16.w,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestedTasks(BuildContext context, List<SuggestedTask> tasks) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyles = Theme.of(context).extension<AppTextStyles>()!;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: colors.surfaceColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Suggested Tasks',
                style: textStyles.labelMedium.copyWith(
                  color: colors.primaryColor,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Import all tasks
                  _showImportDialog(context, tasks);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  minimumSize: Size.zero,
                ),
                child: Text(
                  'Import All',
                  style: textStyles.captionMedium.copyWith(
                    color: colors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ...tasks.map((task) => _buildTaskSuggestion(context, task)),
        ],
      ),
    );
  }

  Widget _buildTaskSuggestion(BuildContext context, SuggestedTask task) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyles = Theme.of(context).extension<AppTextStyles>()!;

    Color priorityColor = task.priority == 'High'
        ? colors.errorColor
        : task.priority == 'Medium'
        ? colors.warningColor
        : colors.successColor;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: textStyles.bodySmall,
                ),
                if (task.description.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    task.description,
                    style: textStyles.captionSmall.copyWith(
                      color: colors.subtitleColor,
                    ),
                  ),
                ],
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        task.priority,
                        style: textStyles.captionSmall.copyWith(
                          color: priorityColor,
                        ),
                      ),
                    ),
                    if (task.estimatedTime.isNotEmpty) ...[
                      SizedBox(width: 8.w),
                      Text(
                        task.estimatedTime,
                        style: textStyles.captionSmall.copyWith(
                          color: colors.subtitleColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Import single task
              _importTask(task);
            },
            icon: Icon(
              Icons.add_circle_outline,
              color: colors.primaryColor,
              size: 20.w,
            ),
            padding: EdgeInsets.all(4.w),
            constraints: BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyles = Theme.of(context).extension<AppTextStyles>()!;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 20.w),
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: colors.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_awesome,
              color: colors.primaryColor,
              size: 16.w,
            ),
          ),
          SizedBox(width: 16.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: colors.cardColor,
              borderRadius: BorderRadius.circular(16.r).copyWith(
                bottomLeft: Radius.circular(4.r),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16.w,
                  height: 16.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(colors.primaryColor),
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  'AI is thinking...',
                  style: textStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyles = Theme.of(context).extension<AppTextStyles>()!;
    final inputDecorations = Theme.of(context).extension<AppInputDecorations>()!;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        border: Border(
          top: BorderSide(
            color: colors.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _promptController,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              decoration: inputDecorations.primaryInputDecoration(
                context: context,
                hintText: 'Ask AI to help with your tasks...',
                prefixIcon: Icon(Icons.chat_bubble_outline),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  _sendMessage(value.trim());
                }
              },
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            decoration: BoxDecoration(
              color: colors.primaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: _isLoading ? null : () {
                if (_promptController.text.trim().isNotEmpty) {
                  _sendMessage(_promptController.text.trim());
                }
              },
              icon: Icon(
                _isLoading ? Icons.stop : Icons.send,
                color: colors.backgroundColor,
                size: 20.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendQuickPrompt(String prompt) {
    _promptController.text = prompt;
    _sendMessage(prompt);
  }

  void _sendMessage(String message) {
    if (_isLoading) return;

    setState(() {
      _messages.add(ChatMessage(
        message: message,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _promptController.clear();
      _isLoading = true;
    });

    _scrollToBottom();

    // TODO: Call AI API
    _simulateAIResponse(message);
  }

  void _simulateAIResponse(String userMessage) {
    // Simulate AI processing delay
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      // Generate mock response based on user message
      String response;
      List<SuggestedTask>? suggestedTasks;

      if (userMessage.toLowerCase().contains('plan') && userMessage.toLowerCase().contains('week')) {
        response = "I've created a balanced weekly plan for you with work and wellness tasks. Here are my suggestions:";
        suggestedTasks = [
          SuggestedTask(
            title: 'Complete project proposal',
            description: 'Finalize and review the Q4 project proposal',
            priority: 'High',
            estimatedTime: '2 hours',
          ),
          SuggestedTask(
            title: 'Team standup meetings',
            description: 'Daily standup meetings with development team',
            priority: 'Medium',
            estimatedTime: '30 min/day',
          ),
          SuggestedTask(
            title: 'Code review',
            description: 'Review pull requests from team members',
            priority: 'Medium',
            estimatedTime: '1 hour',
          ),
          SuggestedTask(
            title: 'Morning meditation',
            description: '10-minute mindfulness meditation',
            priority: 'Low',
            estimatedTime: '10 minutes',
          ),
          SuggestedTask(
            title: 'Evening walk',
            description: 'Take a relaxing walk in the park',
            priority: 'Low',
            estimatedTime: '30 minutes',
          ),
        ];
      } else if (userMessage.toLowerCase().contains('morning routine')) {
        response = "Here's a productive morning routine to start your day right:";
        suggestedTasks = [
          SuggestedTask(
            title: 'Wake up and hydrate',
            description: 'Drink a glass of water upon waking',
            priority: 'High',
            estimatedTime: '2 minutes',
          ),
          SuggestedTask(
            title: 'Exercise or stretch',
            description: 'Light workout or stretching routine',
            priority: 'Medium',
            estimatedTime: '20 minutes',
          ),
          SuggestedTask(
            title: 'Healthy breakfast',
            description: 'Prepare and eat a nutritious breakfast',
            priority: 'High',
            estimatedTime: '15 minutes',
          ),
          SuggestedTask(
            title: 'Review daily goals',
            description: 'Check and prioritize today\'s tasks',
            priority: 'Medium',
            estimatedTime: '10 minutes',
          ),
          SuggestedTask(
            title: 'Read or learn',
            description: 'Read news, articles, or educational content',
            priority: 'Low',
            estimatedTime: '15 minutes',
          ),
        ];
      } else {
        response = "I understand you're looking for help with task management. Here are some general suggestions I can offer:\n\n• Break down large tasks into smaller, manageable steps\n• Prioritize tasks based on urgency and importance\n• Set realistic deadlines and time estimates\n• Use time-blocking to focus on specific tasks\n\nCould you be more specific about what you'd like help with?";
      }

      setState(() {
        _messages.add(ChatMessage(
          message: response,
          isUser: false,
          timestamp: DateTime.now(),
          suggestedTasks: suggestedTasks,
        ));
        _isLoading = false;
      });

      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
      _initializeChat();
    });
  }

  void _showImportDialog(BuildContext context, List<SuggestedTask> tasks) {
    // TODO: Show dialog to select project and import all tasks
    // Show success snackbar after import
  }

  void _importTask(SuggestedTask task) {
    // TODO: Import single task to selected project
    // Show success snackbar
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  void dispose() {
    _promptController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
