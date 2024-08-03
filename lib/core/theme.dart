import 'package:flutter/material.dart';
import 'package:slic/core/color_pallete.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: ColorPallete.primary),
      useMaterial3: true,
      primaryColor: ColorPallete.primary,
      hintColor: ColorPallete.black,
      scaffoldBackgroundColor: ColorPallete.background,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: ColorPallete.text),
        bodyMedium: TextStyle(color: ColorPallete.text),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorPallete.primary,
        foregroundColor: ColorPallete.background,
        scrolledUnderElevation: 0.0,
        titleTextStyle: TextStyle(
          color: ColorPallete.background,
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: ColorPallete.accent,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorPallete.primary,
          foregroundColor: ColorPallete.background,
          textStyle: const TextStyle(
            color: ColorPallete.background,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ),
    );
  }
}
