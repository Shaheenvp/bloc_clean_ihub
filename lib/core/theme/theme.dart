import 'package:bloc_clean_ihub_test/core/theme/ui_consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.textLight,
          fontSize: UIConstants.textSizeMedium, // Responsive font
        ),
        iconTheme: IconThemeData(color: AppColors.textLight),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UIConstants.borderRadiusMedium),
          ),
          elevation: 3.r,
          shadowColor: AppColors.buttonShadow,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UIConstants.borderRadiusMedium),
          borderSide: BorderSide(color: AppColors.formBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UIConstants.borderRadiusMedium),
          borderSide: BorderSide(color: AppColors.formBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UIConstants.borderRadiusMedium),
          borderSide: BorderSide(color: AppColors.primary, width: 2.w),
        ),
        filled: true,
        fillColor: AppColors.formFill,
      ),
      cardTheme: CardTheme(
        color: AppColors.cardBackground,
        elevation: 2.r,
        shadowColor: AppColors.shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIConstants.borderRadiusLarge),
        ),
      ),
    );
  }
}
