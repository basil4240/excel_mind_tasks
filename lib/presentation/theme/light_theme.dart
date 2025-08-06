import 'package:excel_mind_tasks/presentation/theme/styles/app_box_shadows.dart';
import 'package:excel_mind_tasks/presentation/theme/styles/app_input_decorations.dart';
import 'package:excel_mind_tasks/presentation/theme/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'colors.dart';

ThemeData get lightTheme => ThemeData(
    colorScheme: ColorScheme.light(primary: kcLightPrimaryColor),
    primaryColor: kcLightPrimaryColor,
    datePickerTheme: const DatePickerThemeData(),
    brightness: Brightness.light,
    fontFamily: 'Inter',
    extensions: const <ThemeExtension<dynamic>>[
      AppBoxShadows(Brightness.light),
          AppTextStyles(Brightness.light),
          AppInputDecorations(Brightness.light),
      AppColors(brightness: Brightness.light),
    ],
    scaffoldBackgroundColor: kcLightBackgroundColor,
    dividerTheme: const DividerThemeData(color: kcLightDividerColor),
    dividerColor: kcLightDividerColor,
    appBarTheme: const AppBarTheme(
        backgroundColor: kcLightPrimaryColor,
        iconTheme: IconThemeData(color: kcLightIconColor, size: 30),
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 18,
          color: kcLightTextColor,
          fontWeight: FontWeight.w600,
        )));
