import 'package:excel_mind_tasks/dependency_injection.dart';
import 'package:excel_mind_tasks/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/greetings.dart';
import '../../theme/app_colors.dart';
import '../../theme/styles/app_box_shadows.dart';
import '../../theme/styles/app_text_styles.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyles = Theme.of(context).extension<AppTextStyles>()!;
    final shadows = Theme.of(context).extension<AppBoxShadows>()!;

    return Scaffold(
      backgroundColor: colors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getGreeting,
                        style: textStyles.subtitleLarge,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        getIt<AuthProvider>().userPersistingModel?.name ?? 'John',
                        style: textStyles.headingMedium,
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: colors.cardColor,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: shadows.cardShadow,
                    ),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: colors.iconColor,
                      size: 24.w,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // Quick Stats
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Tasks Today',
                      '5',
                      Icons.today,
                      colors.primaryColor,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Completed',
                      '12',
                      Icons.check_circle,
                      colors.successColor,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Projects',
                      '3',
                      Icons.folder,
                      colors.accentColor,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Overdue',
                      '2',
                      Icons.warning,
                      colors.warningColor,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32.h),

              // Today's Tasks
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       'Today\'s Tasks',
              //       style: textStyles.titleLarge,
              //     ),
              //     TextButton(
              //       onPressed: () {},
              //       child: Text(
              //         'View All',
              //         style: textStyles.labelMedium.copyWith(
              //           color: colors.primaryColor,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              //
              // SizedBox(height: 16.h),
              //
              // // Task Items
              // _buildTaskItem(
              //   context,
              //   'Review project proposal',
              //   'Marketing Project',
              //   '10:00 AM',
              //   false,
              //   'High',
              // ),
              //
              // SizedBox(height: 12.h),
              //
              // _buildTaskItem(
              //   context,
              //   'Team meeting',
              //   'Development Team',
              //   '2:00 PM',
              //   false,
              //   'Medium',
              // ),
              //
              // SizedBox(height: 12.h),
              //
              // _buildTaskItem(
              //   context,
              //   'Update documentation',
              //   'Personal',
              //   '4:30 PM',
              //   true,
              //   'Low',
              // ),
              //
              // SizedBox(height: 32.h),
              //
              // // Recent Projects
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       'Recent Projects',
              //       style: textStyles.titleLarge,
              //     ),
              //     TextButton(
              //       onPressed: () {},
              //       child: Text(
              //         'View All',
              //         style: textStyles.labelMedium.copyWith(
              //           color: colors.primaryColor,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              //
              // SizedBox(height: 16.h),
              //
              // // Project Cards
              // _buildProjectCard(
              //   context,
              //   'Mobile App Redesign',
              //   '8/12 tasks completed',
              //   0.67,
              //   colors.primaryColor,
              // ),
              //
              // SizedBox(height: 12.h),
              //
              // _buildProjectCard(
              //   context,
              //   'Marketing Campaign',
              //   '3/8 tasks completed',
              //   0.37,
              //   colors.warningColor,
              // ),
              //
              // SizedBox(height: 12.h),
              //
              // _buildProjectCard(
              //   context,
              //   'Website Development',
              //   '15/15 tasks completed',
              //   1.0,
              //   colors.successColor,
              // ),
              //
              // SizedBox(height: 32.h),
              //
              // // AI Assistant Quick Access
              // Container(
              //   width: double.infinity,
              //   padding: EdgeInsets.all(20.w),
              //   decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //       begin: Alignment.topLeft,
              //       end: Alignment.bottomRight,
              //       colors: [
              //         colors.primaryColor.withOpacity(0.1),
              //         colors.accentColor.withOpacity(0.1),
              //       ],
              //     ),
              //     borderRadius: BorderRadius.circular(16.r),
              //     border: Border.all(
              //       color: colors.primaryColor.withOpacity(0.2),
              //     ),
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         children: [
              //           Icon(
              //             Icons.auto_awesome,
              //             color: colors.primaryColor,
              //             size: 24.w,
              //           ),
              //           SizedBox(width: 8.w),
              //           Text(
              //             'AI Assistant',
              //             style: textStyles.titleMedium.copyWith(
              //               color: colors.primaryColor,
              //             ),
              //           ),
              //         ],
              //       ),
              //       SizedBox(height: 8.h),
              //       Text(
              //         'Let AI help you plan your tasks and optimize your workflow',
              //         style: textStyles.bodyMedium,
              //       ),
              //       SizedBox(height: 16.h),
              //       ElevatedButton(
              //         onPressed: () {},
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor: colors.primaryColor,
              //           foregroundColor: colors.backgroundColor,
              //           elevation: 0,
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(8.r),
              //           ),
              //         ),
              //         child: Text(
              //           'Try AI Assistant',
              //           style: textStyles.buttonMedium,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context,
      String label,
      String value,
      IconData icon,
      Color color,
      ) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyles = Theme.of(context).extension<AppTextStyles>()!;
    final shadows = Theme.of(context).extension<AppBoxShadows>()!;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: shadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: color,
                size: 20.w,
              ),
              Text(
                value,
                style: textStyles.headingMedium.copyWith(
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: textStyles.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(
      BuildContext context,
      String title,
      String project,
      String time,
      bool isCompleted,
      String priority,
      ) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyles = Theme.of(context).extension<AppTextStyles>()!;
    final shadows = Theme.of(context).extension<AppBoxShadows>()!;

    Color priorityColor = priority == 'High'
        ? colors.errorColor
        : priority == 'Medium'
        ? colors.warningColor
        : colors.successColor;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: shadows.todoItemShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isCompleted ? colors.successColor : colors.borderColor,
                width: 2,
              ),
              color: isCompleted ? colors.successColor : Colors.transparent,
            ),
            child: isCompleted
                ? Icon(
              Icons.check,
              size: 12.w,
              color: colors.backgroundColor,
            )
                : null,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: isCompleted
                      ? textStyles.completedTodoTitle
                      : textStyles.todoTitle,
                ),
                SizedBox(height: 4.h),
                Text(
                  project,
                  style: textStyles.todoDescription,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  priority,
                  style: textStyles.captionSmall.copyWith(
                    color: priorityColor,
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                time,
                style: textStyles.todoDate,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(
      BuildContext context,
      String name,
      String progress,
      double progressValue,
      Color color,
      ) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyles = Theme.of(context).extension<AppTextStyles>()!;
    final shadows = Theme.of(context).extension<AppBoxShadows>()!;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: shadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: textStyles.titleSmall,
                ),
              ),
              Text(
                '${(progressValue * 100).toInt()}%',
                style: textStyles.labelMedium.copyWith(
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            progress,
            style: textStyles.bodySmall,
          ),
          SizedBox(height: 12.h),
          LinearProgressIndicator(
            value: progressValue,
            backgroundColor: colors.borderColor.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ],
      ),
    );
  }

}
