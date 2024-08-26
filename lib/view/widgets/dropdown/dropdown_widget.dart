import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:slic/core/color_pallete.dart';

class CustomDropdownButton extends StatefulWidget {
  final List<String> items;
  final String? defaultValue;
  final IconData? icon;
  final String? hintText;
  final void Function(String?) onChanged;

  const CustomDropdownButton({
    super.key,
    required this.items,
    this.defaultValue,
    this.icon,
    required this.onChanged,
    this.hintText,
  });

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>.search(
      hintText: widget.hintText,
      items: widget.items,
      onChanged: widget.onChanged,
      decoration: CustomDropdownDecoration(
        // closedFillColor: ColorPallete.field,
        closedBorder: Border.all(color: ColorPallete.border),
      ),
    );
  }
}
