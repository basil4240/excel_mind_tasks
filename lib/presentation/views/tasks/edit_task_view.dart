import 'package:excel_mind_tasks/domain/entities/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/enums/priority.dart';
import '../../../core/services/dialog_service.dart';
import '../../../core/services/navigation_service.dart';
import '../../../dependency_injection.dart';
import '../../providers/task_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/styles/app_input_decorations.dart';
import '../../theme/styles/app_text_styles.dart';

class EditTaskView extends StatefulWidget {
  final Task task;

  const EditTaskView({super.key, required this.task});

  @override
  State<EditTaskView> createState() => _EditTaskViewState();
}

class _EditTaskViewState extends State<EditTaskView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedProject;
  TaskPriority? _selectedPriority = TaskPriority.high;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _loadTaskData();
  }

  void _loadTaskData() {
    _titleController.text = widget.task.title;
    _descriptionController.text = widget.task.description ?? '';
    _selectedProject = widget.task.projectName;
    _selectedPriority = widget.task.priority;
    _dueDate = widget.task.dueDate;
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
        title: Text('Edit Task', style: textStyles.headingMedium),
        actions: [
          IconButton(
            onPressed: () async {
              var taskProvider = context.read<TaskProvider>();
              var response = await getIt<DialogService>()
                  .showConfirmationDialog(
                    'Delete Task',
                    'Are you sure that you want to delete this Task?',
                  );

              if (response != null && response) {
                // perform delete
                taskProvider.deleteTask(widget.task.id!);
                getIt<NavigationService>().goBack();
                getIt<DialogService>().showSnackBar(
                  'Task Deleted Successfully',
                );
              }
            },
            icon: Icon(Icons.delete_outline, color: colors.errorColor),
          ),
          TextButton(
            onPressed: () async {
              var taskProvider = context.read<TaskProvider>();
              var response = await getIt<DialogService>()
                  .showConfirmationDialog(
                    'Update Task',
                    'Are you sure that you want to update this Task?',
                  );

              if (response != null && response) {
                // perform update
                taskProvider.updateTask(
                  Task(
                    id: widget.task.id,
                    title: _titleController.text,
                      description: _descriptionController.text,
                      priority: _selectedPriority!,
                      dueDate: _dueDate,
                    projectId: widget.task.projectId,
                    createdAt: widget.task.createdAt,
                    updatedAt: DateTime.now(),
                  ),
                );
                getIt<NavigationService>().goBack();
                getIt<NavigationService>().goBack();
                getIt<DialogService>().showSnackBar(
                  'Task Updated Successfully',
                );
              }
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
            // Title
            Text('Task Title', style: textStyles.labelLarge),
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
            Text('Description', style: textStyles.labelLarge),
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
            Text('Project', style: textStyles.labelLarge),
            SizedBox(height: 8.h),

            // GestureDetector(
            //   onTap: () {
            //     // TODO: Show project selection dialog
            //   },
            //   child: Container(
            //     padding: EdgeInsets.all(16.w),
            //     decoration: BoxDecoration(
            //       border: Border.all(color: colors.borderColor, width: 2),
            //       borderRadius: BorderRadius.circular(12.r),
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text(
            //           _selectedProject ?? 'Select Project',
            //           style: textStyles.bodyLarge.copyWith(
            //             color: _selectedProject != null
            //                 ? colors.textColor
            //                 : colors.subtitleColor,
            //           ),
            //         ),
            //         Icon(
            //           Icons.arrow_drop_down,
            //           color: colors.iconColor,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            SizedBox(height: 24.h),

            // Priority Selection
            Text('Priority', style: textStyles.labelLarge),
            SizedBox(height: 12.h),
            Row(
              children: [
                _buildPriorityChip(TaskPriority.high, colors.errorColor),
                SizedBox(width: 12.w),
                _buildPriorityChip(TaskPriority.medium, colors.warningColor),
                SizedBox(width: 12.w),
                _buildPriorityChip(TaskPriority.low, colors.successColor),
              ],
            ),

            SizedBox(height: 24.h),

            // Due Date
            // Text(
            //   'Due Date',
            //   style: textStyles.labelLarge,
            // ),
            // SizedBox(height: 8.h),
            // GestureDetector(
            //   onTap: () {
            //     getIt<DialogService>().showBottomSheet(
            //       Consumer<ProjectProvider>(
            //         builder: (context, projectProvider, child) {
            //           return Container(
            //             margin: EdgeInsets.only(top: 100.h),
            //             child: Column(
            //               children: [
            //                 Row(
            //                   mainAxisAlignment: MainAxisAlignment.start,
            //                   children: [
            //                     IconButton(
            //                       icon: Icon(
            //                         Icons.close,
            //                         color: colors.iconColor,
            //                       ),
            //                       onPressed: () {
            //                         Navigator.of(
            //                           context,
            //                         ).pop(); // Close the bottom sheet
            //                       },
            //                     ),
            //                   ],
            //                 ),
            //                 Expanded(
            //                   child: ListView(
            //                     children:
            //                     projectProvider.allProjects
            //                         .map(
            //                           (e) => GestureDetector(
            //                         child: Card(
            //                           elevation: 4,
            //                           margin: EdgeInsets.symmetric(
            //                             vertical: 8.h,
            //                             horizontal: 16.w,
            //                           ),
            //                           child: ListTile(
            //                             title: Text(
            //                               e.name,
            //                               style: textStyles.bodyLarge
            //                                   .copyWith(
            //                                 fontWeight:
            //                                 FontWeight.bold,
            //                                 color: colors.textColor,
            //                               ),
            //                             ),
            //                           ),
            //                         ),
            //                         onTap: () {
            //                           setState(() {
            //                             _selectedProject = e;
            //                           });
            //                           Navigator.of(context).pop();
            //                         },
            //                       ),
            //                     )
            //                         .toList(),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           );
            //         },
            //       ),
            //     );
            //   },
            //   child: AbsorbPointer(
            //     child: TextField(
            //       decoration: inputDecorations.datePickerInputDecoration(
            //         context: context,
            //         hintText: _dueDate != null
            //             ? '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
            //             : 'Select due date',
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityChip(TaskPriority priority, Color color) {
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
          border: Border.all(color: isSelected ? color : colors.borderColor),
        ),
        child: Text(
          priority.name,
          style: textStyles.labelSmall.copyWith(
            color: isSelected ? color : colors.textColor,
          ),
        ),
      ),
    );
  }
}
