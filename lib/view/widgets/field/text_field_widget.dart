import 'package:flutter/material.dart';
import 'package:slic/core/color_pallete.dart';

class TextFieldWidget extends StatefulWidget {
  final String hintText;
  final bool passwordField;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final bool? readOnly;
  final Color? filledColor;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final String? initialValue;

  const TextFieldWidget({
    super.key,
    this.hintText = '',
    this.passwordField = false,
    this.controller,
    this.suffixIcon,
    this.validator,
    this.readOnly = false,
    this.filledColor,
    this.onChanged,
    this.onEditingComplete,
    this.initialValue,
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
    return TextFormField(
      controller: widget.controller,
      initialValue: widget.initialValue,
      obscureText: obscureText ?? widget.passwordField,
      validator: widget.validator,
      readOnly: widget.readOnly ?? false,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: (value) {
        FocusScope.of(context).nextFocus();
      },
      obscuringCharacter: '*',
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.filledColor ?? ColorPallete.field,
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
