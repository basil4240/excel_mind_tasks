import 'package:excel_mind_tasks/presentation/views/tasks/create_task_view.dart';
import 'package:excel_mind_tasks/presentation/views/tasks/task_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/services/navigation_service.dart';
import '../../../dependency_injection.dart';
import '../../theme/app_colors.dart';
import '../../theme/styles/app_input_decorations.dart';
import '../../theme/styles/app_text_styles.dart';
import '../../widgets/task/task_item.dart';

// Tasks View
class TasksView extends StatelessWidget {
  const TasksView({super.key});

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
              ),
              onChanged: (value) {
                // TODO: Handle search
              },
            ),
          ),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                _buildFilterChip(context, 'All', true),
                SizedBox(width: 8.w),
                _buildFilterChip(context, 'Today', false),
                SizedBox(width: 8.w),
                _buildFilterChip(context, 'High Priority', false),
                SizedBox(width: 8.w),
                _buildFilterChip(context, 'Overdue', false),
                SizedBox(width: 8.w),
                _buildFilterChip(context, 'Completed', false),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // Tasks List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: TaskItem(
                    title: 'Sample Task ${index + 1}',
                    description: 'Task description here',
                    project: 'Project Name',
                    dueDate: 'Today, 10:00 AM',
                    priority:
                        index % 3 == 0
                            ? 'High'
                            : index % 2 == 0
                            ? 'Medium'
                            : 'Low',
                    isCompleted: index % 4 == 0,
                    onTap: () {
                      getIt<NavigationService>().navigateToPage(
                        TaskDetailsView(taskId: '222'),
                      );
                    },
                    onToggle: () {
                      // TODO: Toggle task completion
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
