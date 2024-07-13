import 'package:flutter/material.dart';
import 'package:slic/core/color_pallete.dart';

class CustomSnackbar {
  static void show({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Color backgroundColor = ColorPallete.primary,
    Color textColor = ColorPallete.background,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: textColor),
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      action: onActionPressed == null
          ? null
          : SnackBarAction(
              label: actionLabel ?? 'Undo',
              onPressed: onActionPressed,
              textColor: ColorPallete.accent,
            ),
    ));
  }
}
