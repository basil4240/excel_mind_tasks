import 'package:excel_mind_tasks/core/services/navigation_service.dart';
import 'package:excel_mind_tasks/presentation/providers/project_provider.dart';
import 'package:excel_mind_tasks/presentation/views/projects/create_project.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../dependency_injection.dart';
import '../../theme/app_colors.dart';
import '../../theme/styles/app_input_decorations.dart';
import '../../theme/styles/app_text_styles.dart';
import '../../widgets/project/project_card.dart';
import 'edit_project.dart';

class ProjectsView extends StatefulWidget {
  const ProjectsView({super.key});

  @override
  State<ProjectsView> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends State<ProjectsView> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectProvider>().loadProjects(refresh: true);
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
      context.read<ProjectProvider>().loadMore();
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
                onSearch: () {
                  context.read<ProjectProvider>().searchProjects(
                    _searchController.text,
                  );
                }
              ),
              controller: _searchController,
              onChanged: (value) {
                context.read<ProjectProvider>().searchProjects(value);
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
          //       _buildFilterChip(context, 'Active', false),
          //       SizedBox(width: 8.w),
          //       _buildFilterChip(context, 'Completed', false),
          //       SizedBox(width: 8.w),
          //       _buildFilterChip(context, 'On Hold', false),
          //     ],
          //   ),
          // ),

          SizedBox(height: 16.h),

          // Projects Grid
          Expanded(
            child: Consumer<ProjectProvider>(
              builder: (context, projectProvider, child) {
                if (projectProvider.projects == null &&
                    projectProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (projectProvider.errorMessage != null) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${projectProvider.errorMessage}'),
                      ElevatedButton(
                        onPressed: () {
                          projectProvider.clearError();
                          projectProvider.loadProjects(refresh: true);
                        },
                        child: Text('Retry'),
                      ),
                    ],
                  );
                }

                final projects = projectProvider.projects?.items ?? [];

                if (projects.isEmpty) {
                  return Center(child: Text('No projects found'));
                }

                return RefreshIndicator(
                  onRefresh: () => projectProvider.loadProjects(refresh: true),

                  child: GridView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                      // childAspectRatio: 0.8,
                    ),
                    itemCount: projects.length + (projectProvider.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= projects.length) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final project = projects[index];

                      return ProjectCard(
                        title: project.name,
                        description: project.description ?? 'No description',
                        tasksCount: project.tasksCount,
                        completedTasks: project.completedTasks,
                        progress: project.progress,
                        color: Color(
                          int.parse(project.color!.replaceFirst('#', '0xFF')),
                        ),
                        onTap: () {
                          getIt<NavigationService>().navigateToPage(
                            EditProjectView(project: project),
                          );
                        },
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
