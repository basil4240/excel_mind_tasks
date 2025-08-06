import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/enums/app_button.dart';
import '../../theme/app_colors.dart';
import '../../theme/styles/app_box_shadows.dart';
import '../../theme/styles/app_text_styles.dart';

class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonSize size;
  final AppButtonType type;
  final bool isLoading;
  final Widget? icon;
  final double? width;
  final bool enabled;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.enabled = true,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.enabled && !widget.isLoading) {
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.enabled && !widget.isLoading) {
      _animationController.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.enabled && !widget.isLoading) {
      _animationController.reverse();
    }
  }

  double get _buttonHeight {
    switch (widget.size) {
      case AppButtonSize.small:
        return 40.h;
      case AppButtonSize.medium:
        return 48.h;
      case AppButtonSize.large:
        return 56.h;
    }
  }

  double get _borderRadius {
    switch (widget.size) {
      case AppButtonSize.small:
        return 8.r;
      case AppButtonSize.medium:
        return 12.r;
      case AppButtonSize.large:
        return 16.r;
    }
  }

  EdgeInsets get _padding {
    switch (widget.size) {
      case AppButtonSize.small:
        return EdgeInsets.symmetric(horizontal: 16.w);
      case AppButtonSize.medium:
        return EdgeInsets.symmetric(horizontal: 20.w);
      case AppButtonSize.large:
        return EdgeInsets.symmetric(horizontal: 24.w);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textStyles = Theme.of(context).extension<AppTextStyles>()!;
    final shadows = Theme.of(context).extension<AppBoxShadows>()!;

    Color backgroundColor;
    Color textColor;
    Color borderColor;
    List<BoxShadow> boxShadow;

    switch (widget.type) {
      case AppButtonType.primary:
        backgroundColor = widget.enabled
            ? colors.primaryColor
            : colors.disabledColor;
        textColor = colors.backgroundColor;
        borderColor = Colors.transparent;
        boxShadow = widget.enabled ? shadows.buttonShadow : shadows.noShadow;
        break;
      case AppButtonType.secondary:
        backgroundColor = widget.enabled
            ? colors.secondaryColor
            : colors.disabledColor;
        textColor = colors.backgroundColor;
        borderColor = Colors.transparent;
        boxShadow = widget.enabled ? shadows.buttonShadow : shadows.noShadow;
        break;
      case AppButtonType.outline:
        backgroundColor = Colors.transparent;
        textColor = widget.enabled ? colors.primaryColor : colors.disabledColor;
        borderColor = widget.enabled ? colors.primaryColor : colors.disabledColor;
        boxShadow = shadows.noShadow;
        break;
      case AppButtonType.text:
        backgroundColor = Colors.transparent;
        textColor = widget.enabled ? colors.primaryColor : colors.disabledColor;
        borderColor = Colors.transparent;
        boxShadow = shadows.noShadow;
        break;
    }

    TextStyle buttonTextStyle;
    switch (widget.size) {
      case AppButtonSize.small:
        buttonTextStyle = textStyles.buttonSmall;
        break;
      case AppButtonSize.medium:
        buttonTextStyle = textStyles.buttonMedium;
        break;
      case AppButtonSize.large:
        buttonTextStyle = textStyles.buttonLarge;
        break;
    }

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: widget.enabled && !widget.isLoading ? widget.onPressed : null,
            child: Container(
              width: widget.width,
              height: _buttonHeight,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(_borderRadius),
                border: widget.type == AppButtonType.outline
                    ? Border.all(color: borderColor, width: 1.5)
                    : null,
                boxShadow: boxShadow,
              ),
              child: Padding(
                padding: _padding,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null && !widget.isLoading) ...[
                      widget.icon!,
                      SizedBox(width: 8.w),
                    ],
                    if (widget.isLoading) ...[
                      SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(textColor),
                        ),
                      ),
                      SizedBox(width: 8.w),
                    ],
                    Flexible(
                      child: Text(
                        widget.isLoading ? 'Loading...' : widget.text,
                        style: buttonTextStyle.copyWith(color: textColor),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}