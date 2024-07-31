import 'package:flutter/material.dart';
import 'package:slic/core/color_pallete.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircleAvatar(
        backgroundColor: ColorPallete.accent,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
