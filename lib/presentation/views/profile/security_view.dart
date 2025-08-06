import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/styles/app_box_shadows.dart';
import '../../theme/styles/app_text_styles.dart';

class SecurityView extends StatefulWidget {
  const SecurityView({super.key});

  @override
  State<SecurityView> createState() => _SecurityViewState();
}
class _SecurityViewState extends State<SecurityView> {
  bool _biometricAuth = false;
  bool _twoFactorAuth = false;

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
        title: Text(
          'Security',
          style: textStyles.headingMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            // Authentication Section
            Container(
              decoration: BoxDecoration(
                color: colors.cardColor,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: shadows.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
                    child: Text(
                      'Authentication',
                      style: textStyles.titleSmall.copyWith(
                        color: colors.subtitleColor,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.password,
                      color: colors.iconColor,
                      size: 24.w,
                    ),
                    title: Text(
                      'Change Password',
                      style: textStyles.bodyLarge,
                    ),
                    subtitle: Text(
                      'Update your account password',
                      style: textStyles.bodySmall.copyWith(
                        color: colors.subtitleColor,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: colors.subtitleColor,
                      size: 20.w,
                    ),
                    onTap: () {
                      // TODO: Navigate to ChangePasswordView
                    },
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                  ),
                  SwitchListTile(
                    value: _biometricAuth,
                    onChanged: (value) {
                      setState(() {
                        _biometricAuth = value;
                      });
                      // TODO: Enable/disable biometric auth
                    },
                    title: Text(
                      'Biometric Authentication',
                      style: textStyles.bodyLarge,
                    ),
                    subtitle: Text(
                      'Use fingerprint or face recognition',
                      style: textStyles.bodySmall.copyWith(
                        color: colors.subtitleColor,
                      ),
                    ),
                    secondary: Icon(
                      Icons.fingerprint,
                      color: colors.iconColor,
                      size: 24.w,
                    ),
                    activeColor: colors.primaryColor,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                  ),
                  SwitchListTile(
                    value: _twoFactorAuth,
                    onChanged: (value) {
                      setState(() {
                        _twoFactorAuth = value;
                      });
                      // TODO: Setup 2FA
                    },
                    title: Text(
                      'Two-Factor Authentication',
                      style: textStyles.bodyLarge,
                    ),
                    subtitle: Text(
                      'Add an extra layer of security',
                      style: textStyles.bodySmall.copyWith(
                        color: colors.subtitleColor,
                      ),
                    ),
                    secondary: Icon(
                      Icons.security,
                      color: colors.iconColor,
                      size: 24.w,
                    ),
                    activeColor: colors.primaryColor,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Danger Zone
            Container(
              decoration: BoxDecoration(
                color: colors.cardColor,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: shadows.cardShadow,
                border: Border.all(
                  color: colors.errorColor.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
                    child: Text(
                      'Danger Zone',
                      style: textStyles.titleSmall.copyWith(
                        color: colors.errorColor,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.delete_forever,
                      color: colors.errorColor,
                      size: 24.w,
                    ),
                    title: Text(
                      'Delete Account',
                      style: textStyles.bodyLarge.copyWith(
                        color: colors.errorColor,
                      ),
                    ),
                    subtitle: Text(
                      'Permanently delete your account and all data',
                      style: textStyles.bodySmall.copyWith(
                        color: colors.subtitleColor,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: colors.errorColor,
                      size: 20.w,
                    ),
                    onTap: () {
                      // TODO: Show delete account confirmation
                    },
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}