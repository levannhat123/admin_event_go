import 'package:flutter/material.dart';
import 'package:admin_event_go/core/constants/app_sizes.dart';

class AppTextFieldPassword extends StatefulWidget {
  const AppTextFieldPassword({
    super.key,
    this.controller,
    this.onChanged,
    this.focusNode,
    this.keyboardType,
    this.hintText,
    this.onFieldSubmitted,
    this.textInputAction,
    this.validator,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.enabledBorderColor,
    this.shadowColor,
    this.hintTextColor,
    this.errorTextColor,
    this.prefixIconColor,
    this.suffixIconColor,
  });

  final TextEditingController? controller;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final String? hintText;
  final Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;

  // Tùy chỉnh màu sắc
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? enabledBorderColor;
  final Color? shadowColor;
  final Color? hintTextColor;
  final Color? errorTextColor;
  final Color? prefixIconColor;
  final Color? suffixIconColor;

  @override
  State<AppTextFieldPassword> createState() => _AppTextFieldPasswordState();
}

class _AppTextFieldPasswordState extends State<AppTextFieldPassword> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outlineInputBorder(Color color) => OutlineInputBorder(
          borderSide: BorderSide(color: color, width: AppSizes.size1_2),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        );

    return Stack(
      children: [
        Container(
          height: AppSizes.size48_6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: widget.shadowColor ?? Colors.grey.withOpacity(0.3),
                offset: const Offset(0.0, 3.0),
                blurRadius: 6.0,
              ),
            ],
          ),
        ),
        TextFormField(
          style: TextStyle(
            color: Colors.black,
          ),
          controller: widget.controller,
          onChanged: widget.onChanged,
          obscureText: !showPassword,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          onFieldSubmitted: widget.onFieldSubmitted,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: AppSizes.size16, vertical: AppSizes.size12_6),
            filled: true,
            fillColor: widget.fillColor ?? Colors.pink.shade50,
            border: outlineInputBorder(widget.borderColor ?? Colors.red),
            focusedBorder:
                outlineInputBorder(widget.focusedBorderColor ?? Colors.blue),
            enabledBorder:
                outlineInputBorder(widget.enabledBorderColor ?? Colors.orange),
            hintText: widget.hintText,
            hintStyle: TextStyle(color: widget.hintTextColor ?? Colors.grey),
            labelText: widget.hintText,
            labelStyle: TextStyle(color: widget.hintTextColor ?? Colors.grey),
            prefixIcon: Icon(
              Icons.password,
              color: widget.prefixIconColor ?? Colors.grey,
            ),
            suffixIcon: GestureDetector(
              onTap: () => setState(() => showPassword = !showPassword),
              child: Icon(
                showPassword ? Icons.visibility : Icons.visibility_off,
                color: widget.suffixIconColor ?? Colors.grey,
              ),
            ),
            errorStyle: TextStyle(color: widget.errorTextColor ?? Colors.red),
          ),
        ),
      ],
    );
  }
}
