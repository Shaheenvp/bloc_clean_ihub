import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/ui_consts.dart';

class CommonWidgets {
  static Widget buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: UIConstants.textSizeMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: UIConstants.paddingSmall),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.iconLight),
          ),
        ),
      ],
    );
  }

  static Widget buildStatusIndicator(String status) {
    final bool isActive = status.toLowerCase() == 'active';
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: UIConstants.paddingSmall,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.success.withOpacity(0.2)
            : AppColors.error.withOpacity(0.2),
        borderRadius: BorderRadius.circular(UIConstants.borderRadiusSmall),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: isActive ? AppColors.success : AppColors.error,
          fontWeight: FontWeight.w500,
          fontSize: UIConstants.textSizeSmall,
        ),
      ),
    );
  }

  static Widget buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(UIConstants.borderRadiusMedium),
      child: Container(
        padding: EdgeInsets.all(UIConstants.paddingMedium),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.primary,
          borderRadius: BorderRadius.circular(UIConstants.borderRadiusMedium),
          boxShadow: [
            BoxShadow(
              color: AppColors.iconButtonShadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: iconColor ?? AppColors.textLight,
          size: UIConstants.iconSizeMedium,
        ),
      ),
    );
  }

  static Widget buildLoadingButton({
    required bool isLoading,
    required VoidCallback onPressed,
    required String text,
    String loadingText = 'Loading...',
  }) {
    return SizedBox(
      width: double.infinity,
      height: UIConstants.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CupertinoActivityIndicator(),
                  ),
                  SizedBox(width: UIConstants.paddingSmall),
                  Text(
                    loadingText,
                    style: TextStyle(
                      fontSize: UIConstants.textSizeMedium,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: UIConstants.textSizeMedium,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  static Widget buildInfoItem(
      {required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Container(
          width: UIConstants.avatarSizeMedium,
          height: UIConstants.avatarSizeMedium,
          decoration: BoxDecoration(
            color: AppColors.primaryLighter,
            shape: BoxShape.circle,
          ),
          child: Icon(icon,
              color: AppColors.primary, size: UIConstants.iconSizeMedium),
        ),
        SizedBox(width: UIConstants.paddingMedium),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: UIConstants.textSizeSmall,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 2),
            SizedBox(
              width: 270,
              child: Text(
                overflow: TextOverflow.ellipsis,
                value,
                style: TextStyle(
                    fontSize: UIConstants.textSizeMedium,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget buildDropdownField<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: UIConstants.textSizeMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: UIConstants.paddingSmall),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(UIConstants.borderRadiusMedium),
            border: Border.all(color: AppColors.formBorder),
            color: AppColors.formFill,
          ),
          child: DropdownButtonFormField<T>(
            value: value,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: UIConstants.paddingMedium,
                vertical: UIConstants.paddingMedium,
              ),
              prefixIcon: Icon(icon, color: AppColors.iconLight),
              border: InputBorder.none,
            ),
            borderRadius: BorderRadius.circular(UIConstants.borderRadiusMedium),
            items: items,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
