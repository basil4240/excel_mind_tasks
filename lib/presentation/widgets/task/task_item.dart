import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/styles/app_box_shadows.dart';
import '../../theme/styles/app_text_styles.dart';

class TaskItem extends StatelessWidget {
  final String title;
  final String description;
  final String project;
  final String dueDate;
  final String priority;
  final bool isCompleted;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  const TaskItem({super.key,
    required this.title,
    required this.description,
    required this.project,
    required this.dueDate,
    required this.priority,
    required this.isCompleted,
    required this.onTap,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyles = Theme.of(context).extension<AppTextStyles>()!;
    final shadows = Theme.of(context).extension<AppBoxShadows>()!;

    Color priorityColor = priority == 'High'
        ? colors.errorColor
        : priority == 'Medium'
        ? colors.warningColor
        : colors.successColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: colors.cardColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: shadows.todoItemShadow,
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: onToggle,
              child: Container(
                width: 24.w,
                height: 24.w,
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
                  size: 16.w,
                  color: colors.backgroundColor,
                )
                    : null,
              ),
            ),
            SizedBox(width: 16.w),
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
                    description,
                    style: textStyles.todoDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: colors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          project,
                          style: textStyles.captionSmall.copyWith(
                            color: colors.primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        dueDate,
                        style: textStyles.captionSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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
          ],
        ),
      ),
    );
  }
}