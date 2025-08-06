import 'package:flutter/material.dart';

import '../colors.dart';

class AppBoxShadows extends ThemeExtension<AppBoxShadows> {
  final Brightness brightness;

  const AppBoxShadows(this.brightness);

  // Small elevation shadows
  List<BoxShadow> get shadowSmall => [
    BoxShadow(
      color: brightness == Brightness.light
          ? kcLightShadowColor.withAlpha(25)
          : kcDarkShadowColor.withAlpha(25),
      offset: const Offset(0, 1),
      blurRadius: 3.0,
      spreadRadius: 0.0,
    )
  ];

  // Medium elevation shadows
  List<BoxShadow> get shadowMedium => [
    BoxShadow(
      color: brightness == Brightness.light
          ? kcLightShadowColor.withAlpha(41)
          : kcDarkShadowColor.withAlpha(41),
      offset: const Offset(0, 4),
      blurRadius: 8.0,
      spreadRadius: 0.0,
    )
  ];

  // Large elevation shadows
  List<BoxShadow> get shadowLarge => [
    BoxShadow(
      color: brightness == Brightness.light
          ? kcLightShadowColor.withAlpha(51)
          : kcDarkShadowColor.withAlpha(51),
      offset: const Offset(0, 8),
      blurRadius: 16.0,
      spreadRadius: 0.0,
    )
  ];

  // Extra large elevation shadows
  List<BoxShadow> get shadowXLarge => [
    BoxShadow(
      color: brightness == Brightness.light
          ? kcLightShadowColor.withAlpha(64)
          : kcDarkShadowColor.withAlpha(64),
      offset: const Offset(0, 12),
      blurRadius: 24.0,
      spreadRadius: 0.0,
    )
  ];

  // Card shadows
  List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: brightness == Brightness.light
          ? kcLightShadowColor.withAlpha(31)
          : kcDarkShadowColor.withAlpha(31),
      offset: const Offset(0, 2),
      blurRadius: 8.0,
      spreadRadius: 0.0,
    )
  ];

  // Todo item shadows
  List<BoxShadow> get todoItemShadow => [
    BoxShadow(
      color: brightness == Brightness.light
          ? kcLightShadowColor.withAlpha(20)
          : kcDarkShadowColor.withAlpha(20),
      offset: const Offset(0, 1),
      blurRadius: 4.0,
      spreadRadius: 0.0,
    )
  ];

  // Button shadows
  List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: brightness == Brightness.light
          ? kcLightShadowColor.withAlpha(38)
          : kcDarkShadowColor.withAlpha(38),
      offset: const Offset(0, 2),
      blurRadius: 4.0,
      spreadRadius: 0.0,
    )
  ];

  // Floating Action Button shadows
  List<BoxShadow> get fabShadow => [
    BoxShadow(
      color: brightness == Brightness.light
          ? kcLightShadowColor.withAlpha(61)
          : kcDarkShadowColor.withAlpha(61),
      offset: const Offset(0, 6),
      blurRadius: 12.0,
      spreadRadius: 0.0,
    )
  ];

  // Modal/Dialog shadows
  List<BoxShadow> get modalShadow => [
    BoxShadow(
      color: brightness == Brightness.light
          ? kcLightShadowColor.withAlpha(76)
          : kcDarkShadowColor.withAlpha(76),
      offset: const Offset(0, 10),
      blurRadius: 20.0,
      spreadRadius: 0.0,
    )
  ];

  // Bottom Sheet shadows
  List<BoxShadow> get bottomSheetShadow => [
    BoxShadow(
      color: brightness == Brightness.light
          ? kcLightShadowColor.withAlpha(51)
          : kcDarkShadowColor.withAlpha(51),
      offset: const Offset(0, -2),
      blurRadius: 12.0,
      spreadRadius: 0.0,
    )
  ];

  // Input field shadows
  List<BoxShadow> get inputShadow => [
    BoxShadow(
      color: brightness == Brightness.light
          ? kcLightShadowColor.withAlpha(15)
          : kcDarkShadowColor.withAlpha(15),
      offset: const Offset(0, 1),
      blurRadius: 2.0,
      spreadRadius: 0.0,
    )
  ];

  // Dropdown shadows
  List<BoxShadow> get dropdownShadow => [
    BoxShadow(
      color: brightness == Brightness.light
          ? kcLightShadowColor.withAlpha(46)
          : kcDarkShadowColor.withAlpha(46),
      offset: const Offset(0, 4),
      blurRadius: 12.0,
      spreadRadius: 0.0,
    )
  ];

  // Pressed/Active state shadows
  List<BoxShadow> get pressedShadow => [
    BoxShadow(
      color: brightness == Brightness.light
          ? kcLightShadowColor.withAlpha(10)
          : kcDarkShadowColor.withAlpha(10),
      offset: const Offset(0, 1),
      blurRadius: 2.0,
      spreadRadius: 0.0,
    )
  ];

  // No shadow
  List<BoxShadow> get noShadow => [];

  @override
  String toString() => 'AppBoxShadows(brightness: $brightness)';

  @override
  ThemeExtension<AppBoxShadows> copyWith({Brightness? brightness}) {
    return AppBoxShadows(brightness ?? this.brightness);
  }

  @override
  ThemeExtension<AppBoxShadows> lerp(
      covariant ThemeExtension<AppBoxShadows>? other, double t) {
    if (other is! AppBoxShadows) {
      return this;
    }
    return AppBoxShadows(brightness);
  }
}
