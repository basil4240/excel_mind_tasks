import 'package:excel_mind_tasks/core/enums/priority.dart';
import 'package:excel_mind_tasks/core/services/dialog_service.dart';
import 'package:excel_mind_tasks/dependency_injection.dart';
import 'package:excel_mind_tasks/domain/entities/task.dart';
import 'package:excel_mind_tasks/presentation/providers/project_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/services/navigation_service.dart';
import '../../../domain/entities/project.dart';
import '../../providers/task_provider.dart';
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
  Project? _selectedProject;
  TaskPriority? _selectedPriority = TaskPriority.high;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectProvider>().loadAllProjects(refresh: true);
    });
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
        title: Text('Create Task', style: textStyles.headingMedium),
        actions: [
          TextButton(
            onPressed: () async {

              var projectProvider = context.read<TaskProvider>();

              if(
              _titleController.text.isEmpty ||
              _descriptionController.text.isEmpty ||
              _selectedProject == null ||
              _selectedPriority == null || _dueDate == null
              ) {
                await getIt<DialogService>().showErrorDialog(
                  'Validation Error',
                  'Some input fields are empty. Please make sure you fill all the fields',
                );
                return;
              }

              var response = await getIt<DialogService>().showConfirmationDialog(
                'Create Task',
                'Are you sure that you want to create this task',
              );

              if (response != null && response) {
                // perform create
                projectProvider.createTask(
                    Task(

                        title: _titleController.text,
                        description: _descriptionController.text,
                        projectId: _selectedProject!.id,
                        priority: _selectedPriority!,
                        dueDate: _dueDate,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now()));
                getIt<NavigationService>().goBack();
                getIt<DialogService>().showSnackBar(
                  'Task created Successfully',
                );
              }
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
            GestureDetector(
              onTap: () {
                getIt<DialogService>().showBottomSheet(
                  Consumer<ProjectProvider>(
                    builder: (context, projectProvider, child) {
                      return Container(
                        margin: EdgeInsets.only(top: 100.h),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: colors.iconColor,
                                  ),
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).pop(); // Close the bottom sheet
                                  },
                                ),
                              ],
                            ),
                            Expanded(
                              child: ListView(
                                children:
                                    projectProvider.allProjects
                                        .map(
                                          (e) => GestureDetector(
                                            child: Card(
                                              elevation: 4,
                                              margin: EdgeInsets.symmetric(
                                                vertical: 8.h,
                                                horizontal: 16.w,
                                              ),
                                              child: ListTile(
                                                title: Text(
                                                  e.name,
                                                  style: textStyles.bodyLarge
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: colors.textColor,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                _selectedProject = e;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
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
                      _selectedProject?.name ?? 'Select Project',
                      style: textStyles.bodyLarge.copyWith(
                        color:
                            _selectedProject != null
                                ? colors.textColor
                                : colors.subtitleColor,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: colors.iconColor),
                  ],
                ),
              ),
            ),

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
            Text('Due Date', style: textStyles.labelLarge),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _dueDate ?? DateTime.now(),
                  firstDate: DateTime(2000), // earliest date allowed
                  lastDate: DateTime(2100), // latest date allowed
                );

                if (pickedDate != null && pickedDate != _dueDate) {
                  setState(() {
                    _dueDate = pickedDate;
                  });
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  decoration: inputDecorations.datePickerInputDecoration(
                    context: context,
                    hintText:
                        _dueDate != null
                            ? '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
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
