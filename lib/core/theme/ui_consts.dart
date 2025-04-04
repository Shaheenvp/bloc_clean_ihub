import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UIConstants {
  static double borderRadiusSmall = 10.r;
  static double borderRadiusMedium = 12.r;
  static double borderRadiusLarge = 16.r;
  static double borderRadiusXLarge = 30.r;

  static double paddingSmall = 8.w;
  static double paddingMedium = 16.w;
  static double paddingLarge = 24.w;

  static double textSizeSmall = 13.sp;
  static double textSizeMedium = 15.sp;
  static double textSizeLarge = 17.sp;
  static double textSizeXLarge = 23.sp;

  static double buttonHeight = 55.h;

  static double iconSizeSmall = 18.r;
  static double iconSizeMedium = 24.r;
  static double iconSizeLarge = 32.r;

  static double avatarSizeSmall = 40.r;
  static double avatarSizeMedium = 48.r;
  static double avatarSizeLarge = 100.r;

  static BorderRadius get borderRadiusCircular =>
      BorderRadius.circular(borderRadiusMedium);

  static BorderRadius get topRoundedBorderRadius => BorderRadius.only(
        topLeft: Radius.circular(borderRadiusXLarge),
        topRight: Radius.circular(borderRadiusXLarge),
      );

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8.r,
          offset: Offset(0, 2.h),
        ),
      ];

  static List<BoxShadow> get buttonShadow => [
        BoxShadow(
          color: Colors.blue.withOpacity(0.3),
          blurRadius: 8.r,
          offset: Offset(0, 3.h),
        ),
      ];
}
