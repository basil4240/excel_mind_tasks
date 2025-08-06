import 'package:excel_mind_tasks/core/services/navigation_service.dart';
import 'package:excel_mind_tasks/presentation/views/projects/create_project.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../dependency_injection.dart';
import '../../theme/app_colors.dart';
import '../../theme/styles/app_input_decorations.dart';
import '../../theme/styles/app_text_styles.dart';
import '../../widgets/project/project_card.dart';
import 'edit_project.dart';

class ProjectsView extends StatelessWidget {
  const ProjectsView({super.key});

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
        title: Text('Projects', style: textStyles.headingMedium),
        actions: [
          IconButton(
            onPressed: () {
              getIt<NavigationService>().navigateToPage(CreateProjectView());
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
                hintText: 'Search projects...',
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
                _buildFilterChip(context, 'Active', false),
                SizedBox(width: 8.w),
                _buildFilterChip(context, 'Completed', false),
                SizedBox(width: 8.w),
                _buildFilterChip(context, 'On Hold', false),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // Projects Grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 0.8,
              ),
              itemCount: 8,
              itemBuilder: (context, index) {
                return ProjectCard(
                  title: 'Project ${index + 1}',
                  description: 'Project description here',
                  tasksCount: (index + 1) * 5,
                  completedTasks: (index + 1) * 3,
                  progress: ((index + 1) * 3) / ((index + 1) * 5),
                  color: _getProjectColor(context, index),
                  onTap: () {
                    getIt<NavigationService>().navigateToPage(
                      EditProjectView(projectId: '222'),
                    );
                  },
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

  Color _getProjectColor(BuildContext context, int index) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final colorList = [
      colors.primaryColor,
      colors.successColor,
      colors.warningColor,
      colors.errorColor,
      colors.accentColor,
      colors.infoColor,
    ];
    return colorList[index % colorList.length];
  }
}
