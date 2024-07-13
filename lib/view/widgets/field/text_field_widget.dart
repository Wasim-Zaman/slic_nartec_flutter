import 'package:flutter/material.dart';
import 'package:slic/core/color_pallete.dart';

class TextFieldWidget extends StatefulWidget {
  final String hintText;
  final bool passwordField;
  final TextEditingController? controller;
  final Widget? suffixIcon;

  const TextFieldWidget({
    super.key,
    required this.hintText,
    this.passwordField = false,
    this.controller,
    this.suffixIcon,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool? obscureText;

  @override
  void initState() {
    super.initState();
    if (widget.passwordField == true) obscureText = true;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: obscureText ?? widget.passwordField,
      obscuringCharacter: '*',
      decoration: InputDecoration(
        filled: true,
        fillColor: ColorPallete.field,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide.none,
        ),
        hintText: widget.hintText,
        suffixIcon: widget.passwordField
            ? IconButton(
                icon: Icon(
                  obscureText! ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText!;
                  });
                },
              )
            : widget.suffixIcon,
      ),
    );
  }
}
