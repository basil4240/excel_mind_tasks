import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../colors.dart';

class AppInputDecorations extends ThemeExtension<AppInputDecorations> {
  final Brightness brightness;

  const AppInputDecorations(this.brightness);

  InputDecoration primaryInputDecoration({
    bool enabled = true,
    String? hintText,
    required BuildContext context,
    Widget? prefixIcon,
    double borderRadius = 12.0,
    Widget? suffixIcon,
    Color? borderColor,
  }) =>
      InputDecoration(
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          alignLabelWithHint: true,
          isDense: true,
          filled: !enabled,
          fillColor: !enabled
              ? (brightness == Brightness.light ? kcLightSurfaceColor : kcDarkSurfaceColor)
              : null,
          hintText: hintText,
          contentPadding: const EdgeInsets.all(16),
          hintStyle: TextStyle(
              color: brightness == Brightness.light ? kcLightSubtitleColor : kcDarkSubtitleColor,
              fontFamily: 'Inter',
              fontSize: 16.sp,
              fontWeight: FontWeight.w400),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: !enabled
                  ? (brightness == Brightness.light ? kcLightDisabledColor : kcDarkDisabledColor)
                  : borderColor ?? (brightness == Brightness.light ? kcLightBorderColor : kcDarkBorderColor),
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: !enabled
                  ? (brightness == Brightness.light ? kcLightDisabledColor : kcDarkDisabledColor)
                  : borderColor ?? (brightness == Brightness.light ? kcLightPrimaryColor : kcDarkPrimaryColor),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: !enabled
                  ? (brightness == Brightness.light ? kcLightDisabledColor : kcDarkDisabledColor)
                  : (brightness == Brightness.light ? kcLightErrorColor : kcDarkErrorColor),
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: !enabled
                  ? (brightness == Brightness.light ? kcLightDisabledColor : kcDarkDisabledColor)
                  : (brightness == Brightness.light ? kcLightErrorColor : kcDarkErrorColor),
              width: 3,
            ),
          ));

  InputDecoration searchInputDecoration({
    bool enabled = true,
    String? hintText,
    required BuildContext context,
    Widget? prefixIcon,
    Widget? suffixIcon,
    VoidCallback? onSearch,
  }) =>
      InputDecoration(
          suffixIcon: GestureDetector(
            onTap: onSearch,
            child: suffixIcon ?? Icon(
              Icons.search,
              color: brightness == Brightness.light ? kcLightSubtitleColor : kcDarkSubtitleColor,
            ),
          ),
          prefixIcon: prefixIcon,
          alignLabelWithHint: true,
          isDense: true,
          filled: true,
          fillColor: brightness == Brightness.light ? kcLightSurfaceColor : kcDarkSurfaceColor,
          hintText: hintText ?? 'Search...',
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          hintStyle: TextStyle(
              color: brightness == Brightness.light ? kcLightSubtitleColor : kcDarkSubtitleColor,
              fontFamily: 'Inter',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: BorderSide(
              color: brightness == Brightness.light ? kcLightPrimaryColor : kcDarkPrimaryColor,
              width: 1,
            ),
          ));

  InputDecoration underlineInputDecoration({
    bool enabled = true,
    String? hintText,
    required BuildContext context,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Color? borderColor,
  }) =>
      InputDecoration(
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          alignLabelWithHint: true,
          isDense: true,
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          hintStyle: TextStyle(
              color: brightness == Brightness.light ? kcLightSubtitleColor : kcDarkSubtitleColor,
              fontFamily: 'Inter',
              fontSize: 16.sp,
              fontWeight: FontWeight.w400),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: brightness == Brightness.light ? kcLightBorderColor : kcDarkBorderColor,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: !enabled
                  ? (brightness == Brightness.light ? kcLightDisabledColor : kcDarkDisabledColor)
                  : borderColor ?? (brightness == Brightness.light ? kcLightBorderColor : kcDarkBorderColor),
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: !enabled
                  ? (brightness == Brightness.light ? kcLightDisabledColor : kcDarkDisabledColor)
                  : borderColor ?? (brightness == Brightness.light ? kcLightPrimaryColor : kcDarkPrimaryColor),
              width: 2,
            ),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: brightness == Brightness.light ? kcLightErrorColor : kcDarkErrorColor,
            ),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: brightness == Brightness.light ? kcLightErrorColor : kcDarkErrorColor,
              width: 2,
            ),
          ));

  InputDecoration textAreaInputDecoration({
    bool enabled = true,
    String? hintText,
    required BuildContext context,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Color? borderColor,
    double borderRadius = 12.0,
  }) =>
      InputDecoration(
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          alignLabelWithHint: true,
          isDense: false,
          filled: !enabled,
          fillColor: !enabled
              ? (brightness == Brightness.light ? kcLightSurfaceColor : kcDarkSurfaceColor)
              : null,
          hintText: hintText,
          contentPadding: const EdgeInsets.all(16),
          hintStyle: TextStyle(
              color: brightness == Brightness.light ? kcLightSubtitleColor : kcDarkSubtitleColor,
              fontFamily: 'Inter',
              fontSize: 16.sp,
              fontWeight: FontWeight.w400),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: !enabled
                  ? (brightness == Brightness.light ? kcLightDisabledColor : kcDarkDisabledColor)
                  : borderColor ?? (brightness == Brightness.light ? kcLightBorderColor : kcDarkBorderColor),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: !enabled
                  ? (brightness == Brightness.light ? kcLightDisabledColor : kcDarkDisabledColor)
                  : borderColor ?? (brightness == Brightness.light ? kcLightPrimaryColor : kcDarkPrimaryColor),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: brightness == Brightness.light ? kcLightErrorColor : kcDarkErrorColor,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: brightness == Brightness.light ? kcLightErrorColor : kcDarkErrorColor,
              width: 2,
            ),
          ));

  InputDecoration datePickerInputDecoration({
    bool enabled = true,
    String? hintText,
    required BuildContext context,
    Widget? prefixIcon,
    double borderRadius = 12.0,
  }) =>
      InputDecoration(
          suffixIcon: Icon(
            Icons.calendar_today,
            color: brightness == Brightness.light ? kcLightIconColor : kcDarkIconColor,
            size: 20,
          ),
          prefixIcon: prefixIcon,
          alignLabelWithHint: true,
          isDense: true,
          filled: !enabled,
          fillColor: !enabled
              ? (brightness == Brightness.light ? kcLightSurfaceColor : kcDarkSurfaceColor)
              : null,
          hintText: hintText ?? 'Select date',
          contentPadding: const EdgeInsets.all(16),
          hintStyle: TextStyle(
              color: brightness == Brightness.light ? kcLightSubtitleColor : kcDarkSubtitleColor,
              fontFamily: 'Inter',
              fontSize: 16.sp,
              fontWeight: FontWeight.w400),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: !enabled
                  ? (brightness == Brightness.light ? kcLightDisabledColor : kcDarkDisabledColor)
                  : (brightness == Brightness.light ? kcLightBorderColor : kcDarkBorderColor),
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: !enabled
                  ? (brightness == Brightness.light ? kcLightDisabledColor : kcDarkDisabledColor)
                  : (brightness == Brightness.light ? kcLightPrimaryColor : kcDarkPrimaryColor),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: brightness == Brightness.light ? kcLightErrorColor : kcDarkErrorColor,
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: brightness == Brightness.light ? kcLightErrorColor : kcDarkErrorColor,
              width: 3,
            ),
          ));

  @override
  String toString() => 'AppInputDecorations(brightness: $brightness)';

  @override
  ThemeExtension<AppInputDecorations> copyWith({Brightness? brightness}) {
    return AppInputDecorations(brightness ?? this.brightness);
  }

  @override
  ThemeExtension<AppInputDecorations> lerp(
      covariant ThemeExtension<AppInputDecorations>? other, double t) {
    if (other is! AppInputDecorations) {
      return this;
    }
    return AppInputDecorations(brightness);
  }

}