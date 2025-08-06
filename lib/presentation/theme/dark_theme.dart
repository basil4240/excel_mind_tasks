import 'package:excel_mind_tasks/presentation/theme/colors.dart';
import 'package:excel_mind_tasks/presentation/theme/styles/app_box_shadows.dart';
import 'package:excel_mind_tasks/presentation/theme/styles/app_input_decorations.dart';
import 'package:excel_mind_tasks/presentation/theme/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

ThemeData get darkTheme => ThemeData(
  colorScheme: const ColorScheme.dark(primary: kcDarkPrimaryColor),
  primaryColor: kcDarkPrimaryColor,
  datePickerTheme: const DatePickerThemeData(),
  brightness: Brightness.dark,
  fontFamily: 'Inter',
  extensions: const <ThemeExtension<dynamic>>[
    AppBoxShadows(Brightness.dark),
    AppTextStyles(Brightness.dark),
    AppInputDecorations(Brightness.dark),
    AppColors(brightness: Brightness.dark),
  ],
  scaffoldBackgroundColor: kcDarkBackgroundColor,
  dividerTheme: const DividerThemeData(color: kcDarkDividerColor),
  dividerColor: kcDarkDividerColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: kcDarkBackgroundColor,
    iconTheme: IconThemeData(color: kcDarkBackgroundColor, size: 30),
    elevation: 0,
    titleTextStyle: TextStyle(
      fontFamily: 'Inter',
      fontSize: 18,
      color: kcDarkTextColor,
      fontWeight: FontWeight.w600,
    ),
  ),
);
