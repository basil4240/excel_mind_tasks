import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/styles/app_input_decorations.dart';
import '../../theme/styles/app_text_styles.dart';

class EditProjectView extends StatefulWidget {
  final String projectId;

  const EditProjectView({super.key, required this.projectId});

  @override
  State<EditProjectView> createState() => _EditProjectViewState();
}
class _EditProjectViewState extends State<EditProjectView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Color? _selectedColor;
  String? _selectedStatus = 'Active';
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  @override
  void initState() {
    super.initState();
    // TODO: Load project data and populate fields
    _loadProjectData();
  }

  void _loadProjectData() {
    // TODO: Load existing project data
    _titleController.text = 'Sample Project';
    _descriptionController.text = 'Project description';
    // final colors = Theme.of(context).extension<AppColors>()!;
    _selectedColor = Colors.amber;
    _selectedStatus = 'Active';
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
        title: Text(
          'Edit Project',
          style: textStyles.headingMedium,
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Show delete confirmation dialog
            },
            icon: Icon(
              Icons.delete_outline,
              color: colors.errorColor,
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Update project
            },
            child: Text(
              'Update',
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
            // Project Title
            Text(
              'Project Name',
              style: textStyles.labelLarge,
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _titleController,
              decoration: inputDecorations.primaryInputDecoration(
                context: context,
                hintText: 'Enter project name',
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
                hintText: 'Enter project description',
              ),
            ),

            SizedBox(height: 24.h),

            // Project Color
            Text(
              'Project Color',
              style: textStyles.labelLarge,
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 50.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _getProjectColors(context).length,
                separatorBuilder: (context, index) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  final color = _getProjectColors(context)[index];
                  final isSelected = _selectedColor == color;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                    child: Container(
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: colors.textColor, width: 3)
                            : null,
                      ),
                      child: isSelected
                          ? Icon(
                        Icons.check,
                        color: colors.backgroundColor,
                        size: 24.w,
                      )
                          : null,
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 24.h),

            // Status Selection
            Text(
              'Status',
              style: textStyles.labelLarge,
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                _buildStatusChip('Active', colors.successColor),
                SizedBox(width: 12.w),
                _buildStatusChip('On Hold', colors.warningColor),
                SizedBox(width: 12.w),
                _buildStatusChip('Completed', colors.primaryColor),
              ],
            ),

            SizedBox(height: 24.h),

            // Start Date
            Text(
              'Start Date',
              style: textStyles.labelLarge,
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: () {
                // TODO: Show date picker for start date
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: inputDecorations.datePickerInputDecoration(
                    context: context,
                    hintText: _selectedStartDate != null
                        ? '${_selectedStartDate!.day}/${_selectedStartDate!.month}/${_selectedStartDate!.year}'
                        : 'Select start date',
                  ),
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // End Date
            Text(
              'End Date (Optional)',
              style: textStyles.labelLarge,
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: () {
                // TODO: Show date picker for end date
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: inputDecorations.datePickerInputDecoration(
                    context: context,
                    hintText: _selectedEndDate != null
                        ? '${_selectedEndDate!.day}/${_selectedEndDate!.month}/${_selectedEndDate!.year}'
                        : 'Select end date',
                  ),
                ),
              ),
            ),

            SizedBox(height: 32.h),

            // Project Stats (for edit view)
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: colors.surfaceColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(context, 'Total Tasks', '24'),
                  _buildStatItem(context, 'Completed', '18'),
                  _buildStatItem(context, 'Progress', '75%'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, Color color) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyles = Theme.of(context).extension<AppTextStyles>()!;
    final isSelected = _selectedStatus == status;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = status;
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
          status,
          style: textStyles.labelSmall.copyWith(
            color: isSelected ? color : colors.textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyles = Theme.of(context).extension<AppTextStyles>()!;

    return Column(
      children: [
        Text(
          value,
          style: textStyles.titleMedium.copyWith(
            color: colors.primaryColor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: textStyles.captionMedium,
        ),
      ],
    );
  }

  List<Color> _getProjectColors(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return [
      colors.primaryColor,
      colors.successColor,
      colors.warningColor,
      colors.errorColor,
      colors.accentColor,
      colors.infoColor,
    ];
  }
}
