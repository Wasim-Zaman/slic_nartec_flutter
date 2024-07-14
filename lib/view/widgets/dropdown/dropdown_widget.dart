import 'package:flutter/material.dart';
import 'package:slic/core/color_pallete.dart';

class CustomDropdownButton extends StatefulWidget {
  final List<String> options;
  final String? defaultValue;
  final IconData? icon;
  final void Function(String?) onChanged;

  const CustomDropdownButton({
    super.key,
    required this.options,
    this.defaultValue,
    this.icon,
    required this.onChanged,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: ColorPallete.field,
        borderRadius: BorderRadius.circular(20),
        // border: Border.all(color: ColorPallete.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          icon: const Icon(Icons.arrow_drop_down, color: ColorPallete.border),
          style: const TextStyle(color: ColorPallete.black, fontSize: 16),
          dropdownColor: ColorPallete.background,
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
            widget.onChanged(value);
          },
          items: widget.options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  if (widget.icon != null)
                    Icon(widget.icon, color: ColorPallete.black),
                  const SizedBox(width: 8),
                  Text(value),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
