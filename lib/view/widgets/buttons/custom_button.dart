// lib/widgets/custom_button.dart
import 'package:flutter/material.dart';
import 'package:slic/core/color_pallete.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48.0,
      color: ColorPallete.primary,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: ColorPallete.background,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
