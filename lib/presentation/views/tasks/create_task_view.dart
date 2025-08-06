import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/styles/app_input_decorations.dart';
import '../../theme/styles/app_text_styles.dart';

class CreateTaskView extends StatefulWidget {
  const CreateTaskView({super.key});

  @override
  State<CreateTaskView> createState() => _CreateTaskViewState();
}

class _CreateTaskViewState extends State<CreateTaskView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedProject;
  String? _selectedPriority = 'Medium';
  DateTime? _selectedDate;

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
        title: Text(
          'Create Task',
          style: textStyles.headingMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Save task
            },
            child: Text(
              'Save',
              style: textStyles.buttonMedium.copyWith(
                color: colors.primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Task Title',
              style: textStyles.labelLarge,
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _titleController,
              decoration: inputDecorations.primaryInputDecoration(
                context: context,
                hintText: 'Enter task title',
              ),
            ),

            SizedBox(height: 24.h),

            // Description
            Text(
              'Description',
              style: textStyles.labelLarge,
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: inputDecorations.textAreaInputDecoration(
                context: context,
                hintText: 'Enter task description',
              ),
            ),

            SizedBox(height: 24.h),

            // Project Selection
            Text(
              'Project',
              style: textStyles.labelLarge,
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: () {
                // TODO: Show project selection dialog
              },
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  border: Border.all(color: colors.borderColor, width: 2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedProject ?? 'Select Project',
                      style: textStyles.bodyLarge.copyWith(
                        color: _selectedProject != null
                            ? colors.textColor
                            : colors.subtitleColor,
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: colors.iconColor,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // Priority Selection
            Text(
              'Priority',
              style: textStyles.labelLarge,
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                _buildPriorityChip('High', colors.errorColor),
                SizedBox(width: 12.w),
                _buildPriorityChip('Medium', colors.warningColor),
                SizedBox(width: 12.w),
                _buildPriorityChip('Low', colors.successColor),
              ],
            ),

            SizedBox(height: 24.h),

            // Due Date
            Text(
              'Due Date',
              style: textStyles.labelLarge,
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: () {
                // TODO: Show date picker
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: inputDecorations.datePickerInputDecoration(
                    context: context,
                    hintText: _selectedDate != null
                        ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                        : 'Select due date',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityChip(String priority, Color color) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyles = Theme.of(context).extension<AppTextStyles>()!;
    final isSelected = _selectedPriority == priority;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPriority = priority;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : colors.surfaceColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? color : colors.borderColor,
          ),
        ),
        child: Text(
          priority,
          style: textStyles.labelSmall.copyWith(
            color: isSelected ? color : colors.textColor,
          ),
        ),
      ),
    );
  }
}
