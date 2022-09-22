import 'package:flutter/material.dart';
import 'package:kitaab_project/utils/colors_resource.dart';

class MyCustomTextField extends StatelessWidget {
  const MyCustomTextField(
      {Key? key,
      this.controller,
      this.focusNode,
      this.keyboardType,
      this.textInputAction,
      this.textAlign,
      this.maxLines,
      this.onChanged,
      this.hintText,
      this.height,
      this.width,
      this.validator})
      : super(key: key);

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextAlign? textAlign;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final double? height;
  final double? width;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 45,
      child: TextFormField(
        onChanged: onChanged,
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          filled: true,
          fillColor: ColorResources.colorYellow,
          contentPadding: const EdgeInsets.all(10),
          hintText: hintText ?? "Enter your name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
