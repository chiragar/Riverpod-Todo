import 'package:flutter/material.dart';

import 'app_color.dart';
import 'app_textstyle.dart';

class AppThemes {
  static _border([Color color = AppColor.txtBorderColor]) => OutlineInputBorder(
        borderSide: BorderSide(color: color),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      );
  static final light = ThemeData(
    brightness: Brightness.light,
    dividerColor: AppColor.dividerColor,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: AppColor.appBarColor,
    ),
    cardTheme: const CardTheme(
      elevation: 0,
      color: AppColor.cardColor,
    ),
    scaffoldBackgroundColor: AppColor.whiteColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: AppTextstyle.textStyle14(color: Colors.white),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
        fillColor: AppColor.whiteColor,
        border: _border(),
        enabledBorder: _border(),
        contentPadding: const EdgeInsets.all(8),
        focusedBorder: _border(),
        focusedErrorBorder: _border(AppColor.errorColor),
        errorStyle: AppTextstyle.textStyle14(
            fontWeight: FontWeight.w400, color: AppColor.errorColor),
        errorBorder: _border(AppColor.errorColor),
        hintStyle: AppTextstyle.textStyle14(
            fontWeight: FontWeight.w400, color: AppColor.hintTextColor)),
  );
}
