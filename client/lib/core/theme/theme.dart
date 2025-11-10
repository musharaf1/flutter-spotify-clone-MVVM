import 'package:client/core/theme/app_pallet.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color, width: 3),
  );

  static final darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPallet.backgroundColor,
    inputDecorationTheme: InputDecorationThemeData(
      border: _border(AppPallet.borderColor),
      focusedBorder: _border(AppPallet.gradient1),

      enabledBorder: _border(AppPallet.borderColor),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppPallet.backgroundColor,
    ),
  );
}
