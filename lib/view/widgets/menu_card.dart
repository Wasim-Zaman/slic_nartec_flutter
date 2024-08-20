import 'package:flutter/material.dart';
import 'package:slic/core/color_pallete.dart';

class MenuCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;
  final Color? bgColor;

  const MenuCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.onTap,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: ColorPallete.border,
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(iconPath, height: 60, width: 60),
              const SizedBox(height: 16.0),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14.0),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
