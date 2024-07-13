import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slic/core/color_pallete.dart';

class DropdownWidget extends StatefulWidget {
  const DropdownWidget({
    super.key,
    required this.items,
    this.hint,
    this.value,
    this.onChanged,
  });

  final List<String> items;
  final String? hint;
  final String? value;
  final void Function(String?)? onChanged;
  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  String? value;
  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        hint: widget.hint == null ? null : Text(widget.hint ?? ""),
        onChanged: widget.onChanged,
        items: widget.items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: FittedBox(
              child: Text(
                value,
                style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 5,
          ),
          filled: true,
          fillColor: ColorPallete.field,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
            borderSide:
                const BorderSide(color: ColorPallete.border, width: 0.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
            borderSide:
                const BorderSide(color: ColorPallete.border, width: 0.2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
