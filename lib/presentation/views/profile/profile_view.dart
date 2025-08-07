import 'package:excel_mind_tasks/core/services/dialog_service.dart';
import 'package:excel_mind_tasks/core/services/navigation_service.dart';
import 'package:excel_mind_tasks/presentation/views/auth/login_view.dart';
import 'package:excel_mind_tasks/presentation/views/profile/edit_profile_view.dart';
import 'package:excel_mind_tasks/presentation/views/profile/security_view.dart';
import 'package:excel_mind_tasks/presentation/views/profile/settings_view.dart';
import 'package:excel_mind_tasks/presentation/views/projects/edit_project.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../dependency_injection.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/styles/app_box_shadows.dart';
import '../../theme/styles/app_text_styles.dart';
import '../../widgets/profile/menu_item.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

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
            children: [
              // Profile Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: colors.cardColor,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: shadows.cardShadow,
                ),
                child: Column(
                  children: [
                    // Avatar
                    Container(
                      width: 80.w,
                      height: 80.w,
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
                        size: 40.w,
                        color: colors.primaryColor,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Name and Email
                    Text('John Doe', style: textStyles.headingSmall),
                    SizedBox(height: 4.h),
                    Text(
                      'john.doe@example.com',
                      style: textStyles.bodyMedium.copyWith(
                        color: colors.subtitleColor,
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem(context, 'Projects', '12'),
                        _buildDivider(context),
                        _buildStatItem(context, 'Tasks', '48'),
                        _buildDivider(context),
                        _buildStatItem(context, 'Completed', '32'),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Menu Items
              _buildMenuSection(context, 'Account', [
                MenuItem(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  subtitle: 'Update your personal information',
                  onTap: () {
                    getIt<NavigationService>().navigateToPage(
                      EditProfileView(),
                    );
                  },
                ),
                MenuItem(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  subtitle: 'App preferences and notifications',
                  onTap: () {
                    getIt<NavigationService>().navigateToPage(SettingsView());
                  },
                ),
                MenuItem(
                  icon: Icons.security_outlined,
                  title: 'Security',
                  subtitle: 'Password and security settings',
                  onTap: () {
                    getIt<NavigationService>().navigateToPage(SecurityView());
                  },
                ),
              ]),

              SizedBox(height: 16.h),

              _buildMenuSection(context, 'Data & Privacy', [
                MenuItem(
                  icon: Icons.backup_outlined,
                  title: 'Backup & Sync',
                  subtitle: 'Manage your data backup',
                  onTap: () {
                    // TODO: Navigate to BackupView
                  },
                ),
                MenuItem(
                  icon: Icons.download_outlined,
                  title: 'Export Data',
                  subtitle: 'Download your data',
                  onTap: () {
                    // TODO: Handle data export
                  },
                ),
                MenuItem(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  subtitle: 'Read our privacy policy',
                  onTap: () {
                    // TODO: Open privacy policy
                  },
                ),
              ]),

              SizedBox(height: 16.h),

              _buildMenuSection(context, 'Support', [
                MenuItem(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  subtitle: 'Get help with the app',
                  onTap: () {
                    // TODO: Navigate to HelpView
                  },
                ),
                MenuItem(
                  icon: Icons.feedback_outlined,
                  title: 'Send Feedback',
                  subtitle: 'Help us improve the app',
                  onTap: () {
                    // TODO: Open feedback form
                  },
                ),
                MenuItem(
                  icon: Icons.info_outline,
                  title: 'About',
                  subtitle: 'App version and information',
                  onTap: () {
                    // TODO: Navigate to AboutView
                  },
                ),
              ]),

              SizedBox(height: 32.h),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    var dialogResponse = await getIt<DialogService>()
                        .showConfirmationDialog(
                          'Log Out',
                          'Are you sure that you want to log out?\n\nNote: for now logout just cleared the entire local storage, so a registered users will removed. You will have to create another account again',
                        );
                    if (dialogResponse != null && dialogResponse) {
                      var authProvider = getIt<AuthProvider>();

                      await authProvider.logout();

                    }
                  },
                  icon: Icon(Icons.logout),
                  label: Text('Log Out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.errorColor,
                    side: BorderSide(color: colors.errorColor),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
            ],
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
          style: textStyles.titleMedium.copyWith(color: colors.primaryColor),
        ),
        SizedBox(height: 4.h),
        Text(label, style: textStyles.captionMedium),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(width: 1.w, height: 32.h, color: colors.dividerColor);
  }

  Widget _buildMenuSection(
    BuildContext context,
    String title,
    List<MenuItem> items,
  ) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyles = Theme.of(context).extension<AppTextStyles>()!;
    final shadows = Theme.of(context).extension<AppBoxShadows>()!;

    return Container(
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
              title,
              style: textStyles.titleSmall.copyWith(
                color: colors.subtitleColor,
              ),
            ),
          ),
          ...items.map((item) => _buildMenuItem(context, item)),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, MenuItem item) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyles = Theme.of(context).extension<AppTextStyles>()!;

    return ListTile(
      leading: Icon(item.icon, color: colors.iconColor, size: 24.w),
      title: Text(item.title, style: textStyles.bodyLarge),
      subtitle:
          item.subtitle != null
              ? Text(
                item.subtitle!,
                style: textStyles.bodySmall.copyWith(
                  color: colors.subtitleColor,
                ),
              )
              : null,
      trailing: Icon(
        Icons.chevron_right,
        color: colors.subtitleColor,
        size: 20.w,
      ),
      onTap: item.onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
    );
  }
}
