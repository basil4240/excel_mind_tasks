import 'package:excel_mind_tasks/core/enums/task_status.dart';
import 'package:excel_mind_tasks/domain/entities/task.dart';
import 'package:excel_mind_tasks/presentation/providers/task_provider.dart';
import 'package:excel_mind_tasks/presentation/views/tasks/create_task_view.dart';
import 'package:excel_mind_tasks/presentation/views/tasks/task_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/services/dialog_service.dart';
import '../../../core/services/navigation_service.dart';
import '../../../dependency_injection.dart';
import '../../theme/app_colors.dart';
import '../../theme/styles/app_input_decorations.dart';
import '../../theme/styles/app_text_styles.dart';
import '../../widgets/task/task_item.dart';

// Tasks View
class TasksView extends StatefulWidget {
  const TasksView({super.key});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().loadTasks(refresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<TaskProvider>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyles = Theme.of(context).extension<AppTextStyles>()!;
    final inputDecorations =
        Theme.of(context).extension<AppInputDecorations>()!;

    return Scaffold(
      backgroundColor: colors.backgroundColor,
      appBar: AppBar(
        backgroundColor: colors.backgroundColor,
        elevation: 0,
        title: Text('Tasks', style: textStyles.headingMedium),
        actions: [
          IconButton(
            onPressed: () {
              getIt<NavigationService>().navigateToPage(CreateTaskView());
            },
            icon: Icon(Icons.add, color: colors.iconColor),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(20.w),
            child: TextField(
              decoration: inputDecorations.searchInputDecoration(
                context: context,
                hintText: 'Search tasks...',
                onSearch: () {
                  context.read<TaskProvider>().searchTasks(
                    _searchController.text,
                  );
                },
              ),
              controller: _searchController,
              onChanged: (value) {
                context.read<TaskProvider>().searchTasks(value);
              },
            ),
          ),

          // Filter Chips
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   padding: EdgeInsets.symmetric(horizontal: 20.w),
          //   child: Row(
          //     children: [
          //       _buildFilterChip(context, 'All', true),
          //       SizedBox(width: 8.w),
          //       _buildFilterChip(context, 'Today', false),
          //       SizedBox(width: 8.w),
          //       _buildFilterChip(context, 'High Priority', false),
          //       SizedBox(width: 8.w),
          //       _buildFilterChip(context, 'Overdue', false),
          //       SizedBox(width: 8.w),
          //       _buildFilterChip(context, 'Completed', false),
          //     ],
          //   ),
          // ),
          SizedBox(height: 16.h),

          // Tasks List
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                if (taskProvider.tasks == null && taskProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (taskProvider.errorMessage != null) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${taskProvider.errorMessage}'),
                      ElevatedButton(
                        onPressed: () {
                          taskProvider.clearError();
                          taskProvider.loadTasks(refresh: true);
                        },
                        child: Text('Retry'),
                      ),
                    ],
                  );
                }

                final tasks = taskProvider.tasks?.items ?? [];

                if (tasks.isEmpty) {
                  return Center(child: Text('No tasks found'));
                }

                return RefreshIndicator(
                  onRefresh: () => taskProvider.loadTasks(refresh: true),

                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: tasks.length + (taskProvider.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= tasks.length) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final task = tasks[index];

                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: TaskItem(
                          title: task.title,
                          description: task.description ?? 'No description',
                          project: task.projectName ?? '',
                          dueDate:
                              task.dueDate != null
                                  ? task.dueDate!.toLocal().toString().split(
                                    ' ',
                                  )[0]
                                  : 'No due date',
                          priority: task.priority.name,
                          isCompleted: task.status == TaskStatus.complete,
                          onTap: () {
                            getIt<NavigationService>().navigateToPage(
                              TaskDetailsView(task: task),
                            );
                          },
                          onToggle: () async {
                            var taskProvider = context.read<TaskProvider>();
                            var response = await getIt<DialogService>()
                                .showConfirmationDialog(
                                  'Task Status',
                                  'Are you sure that you want to mark this task as ${task.status == TaskStatus.complete ? 'completed' : 'incomplete'}?',
                                );

                            if (response != null && response) {
                              // perform update
                              taskProvider.updateTask(
                                Task(
                                  id: task.id,
                                  title: task.title,
                                  description: task.description,
                                  status:
                                      task.status == TaskStatus.complete
                                          ? TaskStatus.incomplete
                                          : TaskStatus.complete,
                                  priority: task.priority,
                                  dueDate: task.dueDate,
                                  projectId: task.projectId,
                                  createdAt: task.createdAt,
                                  updatedAt: DateTime.now(),
                                ),
                              );
                              getIt<DialogService>().showSnackBar(
                                'Task Updated Successfully',
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool isSelected) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyles = Theme.of(context).extension<AppTextStyles>()!;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        // TODO: Handle filter selection
      },
      backgroundColor: colors.surfaceColor,
      selectedColor: colors.primaryColor.withOpacity(0.2),
      labelStyle: textStyles.labelSmall.copyWith(
        color: isSelected ? colors.primaryColor : colors.textColor,
      ),
      side: BorderSide(
        color: isSelected ? colors.primaryColor : colors.borderColor,
      ),
    );
  }
}
