import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/styles/app_input_decorations.dart';
import '../../theme/styles/app_text_styles.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // TODO: Load user data
    _loadUserData();
  }

  void _loadUserData() {
    _nameController.text = 'John Doe';
    _emailController.text = 'john.doe@example.com';
    _phoneController.text = '+1 234 567 8900';
    _bioController.text = 'Product manager passionate about productivity.';
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
          'Edit Profile',
          style: textStyles.headingMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Save profile changes
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
          children: [
            // Avatar Section
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.primaryColor.withOpacity(0.1),
                      border: Border.all(
                        color: colors.primaryColor,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 50.w,
                      color: colors.primaryColor,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Show image picker
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: colors.primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: colors.shadowColor.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 16.w,
                          color: colors.backgroundColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32.h),

            // Form Fields
            _buildFormField(
              context,
              'Full Name',
              _nameController,
              inputDecorations.primaryInputDecoration(
                context: context,
                hintText: 'Enter your full name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),

            SizedBox(height: 20.h),

            _buildFormField(
              context,
              'Email Address',
              _emailController,
              inputDecorations.primaryInputDecoration(
                context: context,
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),

            SizedBox(height: 20.h),

            _buildFormField(
              context,
              'Phone Number',
              _phoneController,
              inputDecorations.primaryInputDecoration(
                context: context,
                hintText: 'Enter your phone number',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),

            SizedBox(height: 20.h),

            _buildFormField(
              context,
              'Bio',
              _bioController,
              inputDecorations.textAreaInputDecoration(
                context: context,
                hintText: 'Tell us about yourself',
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(
      BuildContext context,
      String label,
      TextEditingController controller,
      InputDecoration decoration, {
        int maxLines = 1,
      }) {
    final textStyles = Theme.of(context).extension<AppTextStyles>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textStyles.labelLarge,
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          decoration: decoration,
          maxLines: maxLines,
        ),
      ],
    );
  }
}
