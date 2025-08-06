import 'package:excel_mind_tasks/presentation/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles extends ThemeExtension<AppTextStyles> {
  final Brightness brightness;

  const AppTextStyles(this.brightness);

  // Heading Styles
  TextStyle get headingLarge => TextStyle(
    fontFamily: 'Inter',
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    color: brightness == Brightness.light ? kcLightTextColor : kcDarkTextColor,
  );

  TextStyle get headingMedium => TextStyle(
    fontFamily: 'Inter',
    fontSize: 28.sp,
    fontWeight: FontWeight.w600,
    color: brightness == Brightness.light ? kcLightTextColor : kcDarkTextColor,
  );

  TextStyle get headingSmall => TextStyle(
    fontFamily: 'Inter',
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    color: brightness == Brightness.light ? kcLightTextColor : kcDarkTextColor,
  );

  // Title Styles
  TextStyle get titleLarge => TextStyle(
    fontFamily: 'Inter',
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
    color: brightness == Brightness.light ? kcLightTextColor : kcDarkTextColor,
  );

  TextStyle get titleMedium => TextStyle(
    fontFamily: 'Inter',
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
    color: brightness == Brightness.light ? kcLightTextColor : kcDarkTextColor,
  );

  TextStyle get titleSmall => TextStyle(
    fontFamily: 'Inter',
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
    color: brightness == Brightness.light ? kcLightTextColor : kcDarkTextColor,
  );

  // Body Styles
  TextStyle get bodyLarge => TextStyle(
    fontFamily: 'Inter',
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: brightness == Brightness.light ? kcLightTextColor : kcDarkTextColor,
  );

  TextStyle get bodyMedium => TextStyle(
    fontFamily: 'Inter',
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: brightness == Brightness.light ? kcLightTextColor : kcDarkTextColor,
  );

  TextStyle get bodySmall => TextStyle(
    fontFamily: 'Inter',
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: brightness == Brightness.light ? kcLightTextColor : kcDarkTextColor,
  );

  // Subtitle Styles
  TextStyle get subtitleLarge => TextStyle(
    fontFamily: 'Inter',
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: brightness == Brightness.light ? kcLightSubtitleColor : kcDarkSubtitleColor,
  );

  TextStyle get subtitleMedium => TextStyle(
    fontFamily: 'Inter',
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: brightness == Brightness.light ? kcLightSubtitleColor : kcDarkSubtitleColor,
  );

  TextStyle get subtitleSmall => TextStyle(
    fontFamily: 'Inter',
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: brightness == Brightness.light ? kcLightSubtitleColor : kcDarkSubtitleColor,
  );

  // Button Styles
  TextStyle get buttonLarge => TextStyle(
    fontFamily: 'Inter',
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: brightness == Brightness.light ? kcLightBackgroundColor : kcDarkBackgroundColor,
  );

  TextStyle get buttonMedium => TextStyle(
    fontFamily: 'Inter',
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: brightness == Brightness.light ? kcLightBackgroundColor : kcDarkBackgroundColor,
  );

  TextStyle get buttonSmall => TextStyle(
    fontFamily: 'Inter',
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: brightness == Brightness.light ? kcLightBackgroundColor : kcDarkBackgroundColor,
  );

  // Caption Styles
  TextStyle get captionLarge => TextStyle(
    fontFamily: 'Inter',
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: brightness == Brightness.light ? kcLightSubtitleColor : kcDarkSubtitleColor,
  );

  TextStyle get captionMedium => TextStyle(
    fontFamily: 'Inter',
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    color: brightness == Brightness.light ? kcLightSubtitleColor : kcDarkSubtitleColor,
  );

  TextStyle get captionSmall => TextStyle(
    fontFamily: 'Inter',
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    color: brightness == Brightness.light ? kcLightSubtitleColor : kcDarkSubtitleColor,
  );

  // Label Styles
  TextStyle get labelLarge => TextStyle(
    fontFamily: 'Inter',
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: brightness == Brightness.light ? kcLightTextColor : kcDarkTextColor,
  );

  TextStyle get labelMedium => TextStyle(
    fontFamily: 'Inter',
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: brightness == Brightness.light ? kcLightTextColor : kcDarkTextColor,
  );

  TextStyle get labelSmall => TextStyle(
    fontFamily: 'Inter',
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    color: brightness == Brightness.light ? kcLightTextColor : kcDarkTextColor,
  );

  // Special Styles
  TextStyle get overline => TextStyle(
    fontFamily: 'Inter',
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.5,
    color: brightness == Brightness.light ? kcLightSubtitleColor : kcDarkSubtitleColor,
  );

  TextStyle get errorText => TextStyle(
    fontFamily: 'Inter',
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: brightness == Brightness.light ? kcLightErrorColor : kcDarkErrorColor,
  );

  TextStyle get linkText => TextStyle(
    fontFamily: 'Inter',
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: brightness == Brightness.light ? kcLightPrimaryColor : kcDarkPrimaryColor,
    decoration: TextDecoration.underline,
  );

  TextStyle get todoTitle => TextStyle(
    fontFamily: 'Inter',
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: brightness == Brightness.light ? kcLightTextColor : kcDarkTextColor,
  );

  TextStyle get todoDescription => TextStyle(
    fontFamily: 'Inter',
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: brightness == Brightness.light ? kcLightSubtitleColor : kcDarkSubtitleColor,
  );

  TextStyle get todoDate => TextStyle(
    fontFamily: 'Inter',
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: brightness == Brightness.light ? kcLightSubtitleColor : kcDarkSubtitleColor,
  );

  TextStyle get completedTodoTitle => TextStyle(
    fontFamily: 'Inter',
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: brightness == Brightness.light ? kcLightDisabledColor : kcDarkDisabledColor,
    decoration: TextDecoration.lineThrough,
  );

  @override
  String toString() => 'AppTextStyles(brightness: $brightness)';

  @override
  ThemeExtension<AppTextStyles> copyWith({Brightness? brightness}) {
    return AppTextStyles(brightness ?? this.brightness);
  }

  @override
  ThemeExtension<AppTextStyles> lerp(
      covariant ThemeExtension<AppTextStyles>? other,
      double t,
      ) {
    if (other is! AppTextStyles) {
      return this;
    }
    return AppTextStyles(brightness);
  }
}