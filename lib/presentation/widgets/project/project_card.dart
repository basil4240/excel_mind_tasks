import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/styles/app_box_shadows.dart';
import '../../theme/styles/app_text_styles.dart';

class ProjectCard extends StatelessWidget {
  final String title;
  final String description;
  final int tasksCount;
  final int completedTasks;
  final double progress;
  final Color color;
  final VoidCallback onTap;

  const ProjectCard({super.key,
    required this.title,
    required this.description,
    required this.tasksCount,
    required this.completedTasks,
    required this.progress,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyles = Theme.of(context).extension<AppTextStyles>()!;
    final shadows = Theme.of(context).extension<AppBoxShadows>()!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: colors.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: shadows.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Header
            Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    title,
                    style: textStyles.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.more_vert,
                  size: 16.w,
                  color: colors.subtitleColor,
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Description
            Text(
              description,
              style: textStyles.bodySmall,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            const Spacer(),

            // Progress
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$completedTasks/$tasksCount tasks',
                      style: textStyles.captionMedium,
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: textStyles.captionMedium.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: colors.borderColor.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
