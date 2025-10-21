import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.hintText,
    this.prefixIcon,
    this.onFieldSubmitted,
    this.textInputAction,
    this.validator,
    this.readOnly = false,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.enabledBorderColor,
    this.shadowColor,
    this.hintTextColor,
    this.errorColor,
    this.suffixIcon,
    this.lableText,
    this.onTap, this.maxLines,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final String? hintText;
  final String? lableText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onFieldSubmitted;
  final VoidCallback? onTap;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final bool readOnly;

  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? enabledBorderColor;
  final Color? shadowColor;
  final Color? hintTextColor;
  final Color? errorColor;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outlineInputBorder(Color color) => OutlineInputBorder(
          borderSide: BorderSide(color: color, width: 1.2),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        );

    return Stack(
      children: [
        Container(
          height: 48.6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: shadowColor ?? Colors.grey.withOpacity(0.3),
                offset: const Offset(0.0, 3.0),
                blurRadius: 6.0,
              ),
            ],
          ),
        ),
        TextFormField(
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          maxLines: maxLines,
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          onFieldSubmitted: onFieldSubmitted,
          onTap: onTap,
          textInputAction: textInputAction,
          validator: validator,
          readOnly: readOnly,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.6),
            filled: true,
            fillColor: fillColor ?? Colors.pink.shade50,
            border: outlineInputBorder(borderColor ?? Colors.red,),
            focusedBorder:
                outlineInputBorder(focusedBorderColor ?? Colors.blue),
            enabledBorder:
                outlineInputBorder(enabledBorderColor ?? Colors.orange),
            hintText: hintText,
            hintStyle: TextStyle(color: hintTextColor ?? Colors.grey),
            labelText: lableText,
            labelStyle: TextStyle(color: hintTextColor ?? Colors.grey),
            prefixIcon: prefixIcon,

            suffixIcon: suffixIcon,
            errorStyle: TextStyle(color: errorColor ?? Colors.red),
          ),
        ),
      ],
    );
  }
}
