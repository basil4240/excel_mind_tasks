import 'package:excel_mind_tasks/core/enums/priority.dart';
import 'package:excel_mind_tasks/core/enums/task_status.dart';
import 'package:excel_mind_tasks/presentation/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/services/dialog_service.dart';
import '../../../core/services/navigation_service.dart';
import '../../../dependency_injection.dart';
import '../../../domain/entities/task.dart';
import '../../theme/app_colors.dart';
import '../../theme/styles/app_box_shadows.dart';
import '../../theme/styles/app_text_styles.dart';
import 'edit_task_view.dart';

class TaskDetailsView extends StatelessWidget {
  final Task task;

  const TaskDetailsView({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyles = Theme.of(context).extension<AppTextStyles>()!;
    final shadows = Theme.of(context).extension<AppBoxShadows>()!;

    return Scaffold(
      backgroundColor: colors.backgroundColor,
      appBar: AppBar(
        backgroundColor: colors.backgroundColor,
        elevation: 0,
        title: Text('Task Details', style: textStyles.headingMedium),
        actions: [
          IconButton(
            onPressed: () {
              getIt<NavigationService>().navigateToPage(
                EditTaskView(task: task),
              );
            },
            icon: Icon(Icons.edit_outlined, color: colors.iconColor),
          ),
          IconButton(
            onPressed: () async {
              var taskProvider = context.read<TaskProvider>();
              var response = await getIt<DialogService>().showConfirmationDialog(
                'Delete Task',
                'Are you sure that you want to delete this Task?',
              );

              if (response != null && response) {
                // perform delete
                taskProvider.deleteTask(task.id!);
                getIt<NavigationService>().goBack();
                getIt<DialogService>().showSnackBar(
                  'Task Deleted Successfully',
                );
              }
            },
            icon: Icon(Icons.delete_forever_outlined, color: colors.errorColor),
          ),

          // PopupMenuButton(
          //   icon: Icon(Icons.more_vert, color: colors.iconColor),
          //   itemBuilder: (context) => [
          //     PopupMenuItem(
          //       onTap: () {
          //         // TODO: Duplicate task
          //       },
          //       child: Text('Duplicate'),
          //     ),
          //     PopupMenuItem(
          //       onTap: () {
          //         // TODO: Share task
          //       },
          //       child: Text('Share'),
          //     ),
          //     PopupMenuItem(
          //       onTap: () {
          //         // TODO: Delete task
          //       },
          //       child: Text('Delete'),
          //     ),
          //   ],
          // ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Header
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: colors.cardColor,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: shadows.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colors.successColor,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.check,
                          size: 16.w,
                          color: colors.successColor,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(task.title, style: textStyles.titleLarge),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: colors.errorColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          task.priority.name,
                          style: textStyles.captionMedium.copyWith(
                            color:
                                task.priority == TaskPriority.high
                                    ? colors.errorColor
                                    : task.priority == TaskPriority.medium
                                    ? colors.warningColor
                                    : colors.successColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    task.description ?? '',
                    style: textStyles.bodyLarge,
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Task Info
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: colors.cardColor,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: shadows.cardShadow,
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    context,
                    'Project', task.projectName!,
                    Icons.folder_outlined,
                  ),
                  SizedBox(height: 16.h),
                  _buildInfoRow(
                    context,
                    'Due Date', DateFormat('dd/MM/yyyy hh:mm a').format(task.dueDate!),
                    Icons.schedule_outlined,
                  ),
                  SizedBox(height: 16.h),
                  _buildInfoRow(
                    context,
                    'Created',
                    '${task.createdAt.day} days ago',
                    Icons.calendar_today_outlined,
                  ),
                  SizedBox(height: 16.h),
                  _buildInfoRow(
                    context,
                    'Status',
                    task.status.name,
                    Icons.play_circle_outline,
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),
            //
            // // Actions
            // Container(
            //   padding: EdgeInsets.all(20.w),
            //   decoration: BoxDecoration(
            //     color: colors.cardColor,
            //     borderRadius: BorderRadius.circular(16.r),
            //     boxShadow: shadows.cardShadow,
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text('Quick Actions', style: textStyles.titleMedium),
            //       SizedBox(height: 16.h),
            //       Row(
            //         children: [
            //           Expanded(
            //             child: ElevatedButton.icon(
            //               onPressed: () {
            //                 // TODO: Mark as complete/incomplete
            //               },
            //               icon: Icon(Icons.check_circle_outline),
            //               label: Text(task.status.name),
            //               style: ElevatedButton.styleFrom(
            //                 backgroundColor: task.status == TaskStatus.complete ? colors.successColor : colors.errorColor,
            //                 foregroundColor: colors.backgroundColor,
            //                 shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(8.r),
            //                 ),
            //               ),
            //             ),
            //           ),
            //           // SizedBox(width: 12.w),
            //           // Expanded(
            //           //   child: OutlinedButton.icon(
            //           //     onPressed: () {
            //           //       // TODO: Suggest new time with AI
            //           //     },
            //           //     icon: Icon(Icons.auto_awesome),
            //           //     label: Text('Reschedule'),
            //           //     style: OutlinedButton.styleFrom(
            //           //       foregroundColor: colors.primaryColor,
            //           //       side: BorderSide(color: colors.primaryColor),
            //           //       shape: RoundedRectangleBorder(
            //           //         borderRadius: BorderRadius.circular(8.r),
            //           //       ),
            //           //     ),
            //           //   ),
            //           // ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyles = Theme.of(context).extension<AppTextStyles>()!;

    return Row(
      children: [
        Icon(icon, size: 20.w, color: colors.iconColor),
        SizedBox(width: 12.w),
        Text(
          label,
          style: textStyles.bodyMedium.copyWith(color: colors.subtitleColor),
        ),
        const Spacer(),
        Text(value, style: textStyles.bodyMedium),
      ],
    );
  }
}
