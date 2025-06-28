import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import '../constants/app_theme.dart';

extension AppContextExtensions on BuildContext {
  // Colors
  Color get primaryColor => AppTheme.primaryColor;
  Color get accentColor => AppTheme.accentColor;
  Color get backgroundColor => AppTheme.backgroundColor;
  Color get splashCircleColor => AppTheme.splashCircleColor;

  // Text styles
  TextStyle get headline => AppTheme.headline;
  TextStyle get body => AppTheme.body;
  TextStyle get caption => AppTheme.caption;

  // Dimensions
  double get splashIconSize => AppDimensions.splashIconSize;
  double get splashCirclePadding => AppDimensions.splashCirclePadding;
  double get splashBottomSpacing => AppDimensions.splashBottomSpacing;
  double get splashTextSpacing => AppDimensions.splashTextSpacing;
  double get pagePadding => AppDimensions.pagePadding;
  double get cardRadius => AppDimensions.cardRadius;
  double get buttonHeight => AppDimensions.buttonHeight;
  double get iconSize => AppDimensions.iconSize;

  // MediaQuery helpers
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  double get topPadding => MediaQuery.of(this).padding.top;
  double get bottomPadding => MediaQuery.of(this).padding.bottom;
}
