import 'package:excel_mind_tasks/dependency_injection.dart';
import 'package:excel_mind_tasks/presentation/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/user_persisting_model.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/styles/app_box_shadows.dart';
import '../../theme/styles/app_text_styles.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}
class _SettingsViewState extends State<SettingsView> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _taskReminders = true;
  bool _projectUpdates = true;
  bool _darkMode = getIt<AuthProvider>().userPersistingModel?.isDark ?? false;
  final String _selectedLanguage = 'English';

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
          'Settings',
          style: textStyles.headingMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            // Appearance Section
            _buildSettingsSection(
              context,
              'Appearance',
              [
                _buildSwitchTile(
                  context,
                  'Dark Mode',
                  'Switch between light and dark theme',
                  Icons.dark_mode_outlined,
                  _darkMode,
                      (value) async {

                        setState(() {
                          _darkMode = value;
                        });

                    // save the state
                        await getIt<AuthProvider>().updateUser(
                            UserPersistingModel(
                                id: getIt<AuthProvider>().userPersistingModel?.id ?? '',
                                email: getIt<AuthProvider>().userPersistingModel?.email ?? '',
                                name: getIt<AuthProvider>().userPersistingModel?.name ?? '',
                                password: getIt<AuthProvider>().userPersistingModel?.password ?? '' ?? '',
                                phone: getIt<AuthProvider>().userPersistingModel?.phone ?? '',
                                bio: getIt<AuthProvider>().userPersistingModel?.bio ?? '',
                                isDark: _darkMode
                            )
                        );

                    getIt<ThemeProvider>().toggleDarkThemeMode(_darkMode);
                  },
                ),
                _buildListTile(
                  context,
                  'Language',
                  _selectedLanguage,
                  Icons.language_outlined,
                      () {
                    // TODO: Show language selection
                  },
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Notifications Section
            _buildSettingsSection(
              context,
              'Notifications',
              [
                _buildSwitchTile(
                  context,
                  'Push Notifications',
                  'Receive push notifications',
                  Icons.notifications_outlined,
                  _pushNotifications,
                      (value) {
                    setState(() {
                      _pushNotifications = value;
                    });
                    // TODO: Update notification settings
                  },
                ),
                _buildSwitchTile(
                  context,
                  'Email Notifications',
                  'Receive email updates',
                  Icons.email_outlined,
                  _emailNotifications,
                      (value) {
                    setState(() {
                      _emailNotifications = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  context,
                  'Task Reminders',
                  'Get reminders for due tasks',
                  Icons.access_time_outlined,
                  _taskReminders,
                      (value) {
                    setState(() {
                      _taskReminders = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  context,
                  'Project Updates',
                  'Notifications for project changes',
                  Icons.update_outlined,
                  _projectUpdates,
                      (value) {
                    setState(() {
                      _projectUpdates = value;
                    });
                  },
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Data & Storage Section
            _buildSettingsSection(
              context,
              'Data & Storage',
              [
                _buildListTile(
                  context,
                  'Clear Cache',
                  'Free up storage space',
                  Icons.storage_outlined,
                      () {
                    // TODO: Show clear cache confirmation
                  },
                ),
                _buildListTile(
                  context,
                  'Offline Storage',
                  'Manage offline data',
                  Icons.offline_pin_outlined,
                      () {
                    // TODO: Navigate to offline storage settings
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(
      BuildContext context,
      String title,
      List<Widget> children,
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
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      bool value,
      ValueChanged<bool> onChanged,
      ) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyles = Theme.of(context).extension<AppTextStyles>()!;

    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(
        title,
        style: textStyles.bodyLarge,
      ),
      subtitle: Text(
        subtitle,
        style: textStyles.bodySmall.copyWith(
          color: colors.subtitleColor,
        ),
      ),
      secondary: Icon(
        icon,
        color: colors.iconColor,
        size: 24.w,
      ),
      activeColor: colors.primaryColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
    );
  }

  Widget _buildListTile(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      VoidCallback onTap,
      ) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyles = Theme.of(context).extension<AppTextStyles>()!;

    return ListTile(
      leading: Icon(
        icon,
        color: colors.iconColor,
        size: 24.w,
      ),
      title: Text(
        title,
        style: textStyles.bodyLarge,
      ),
      subtitle: Text(
        subtitle,
        style: textStyles.bodySmall.copyWith(
          color: colors.subtitleColor,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: colors.subtitleColor,
        size: 20.w,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
    );
  }
}
