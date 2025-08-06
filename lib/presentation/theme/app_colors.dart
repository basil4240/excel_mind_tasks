import 'package:flutter/material.dart';

import 'colors.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Brightness? brightness;

  Color get primaryColor =>
      brightness == Brightness.light ? kcLightPrimaryColor : kcDarkPrimaryColor;

  Color get secondaryColor =>
      brightness == Brightness.light ? kcLightSecondaryColor : kcDarkSecondaryColor;

  Color get backgroundColor =>
      brightness == Brightness.light ? kcLightBackgroundColor : kcDarkBackgroundColor;

  Color get surfaceColor =>
      brightness == Brightness.light ? kcLightSurfaceColor : kcDarkSurfaceColor;

  Color get cardColor =>
      brightness == Brightness.light ? kcLightCardColor : kcDarkCardColor;

  Color get textColor =>
      brightness == Brightness.light ? kcLightTextColor : kcDarkTextColor;

  Color get subtitleColor =>
      brightness == Brightness.light ? kcLightSubtitleColor : kcDarkSubtitleColor;

  Color get borderColor =>
      brightness == Brightness.light ? kcLightBorderColor : kcDarkBorderColor;

  Color get successColor =>
      brightness == Brightness.light ? kcLightSuccessColor : kcDarkSuccessColor;

  Color get warningColor =>
      brightness == Brightness.light ? kcLightWarningColor : kcDarkWarningColor;

  Color get errorColor =>
      brightness == Brightness.light ? kcLightErrorColor : kcDarkErrorColor;

  Color get infoColor =>
      brightness == Brightness.light ? kcLightInfoColor : kcDarkInfoColor;

  Color get accentColor =>
      brightness == Brightness.light ? kcLightAccentColor : kcDarkAccentColor;

  Color get disabledColor =>
      brightness == Brightness.light ? kcLightDisabledColor : kcDarkDisabledColor;

  Color get iconColor =>
      brightness == Brightness.light ? kcLightIconColor : kcDarkIconColor;

  Color get dividerColor =>
      brightness == Brightness.light ? kcLightDividerColor : kcDarkDividerColor;

  Color get highlightColor =>
      brightness == Brightness.light ? kcLightHighlightColor : kcDarkHighlightColor;

  Color get shadowColor =>
      brightness == Brightness.light ? kcLightShadowColor : kcDarkShadowColor;

  const AppColors({
    required this.brightness,
  });

  @override
  ThemeExtension<AppColors> copyWith({Brightness? brightness}) {
    return AppColors(brightness: this.brightness ?? brightness);
  }

  @override
  ThemeExtension<AppColors> lerp(
      covariant ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return const AppColors(brightness: null);
  }
}