import 'package:flutter/material.dart';

import '../utils/colors_resource.dart';

class MyCustomButton extends StatelessWidget {
  const MyCustomButton(
      {Key? key,
      this.text,
      this.widget,
      this.onPressed,
      this.height,
      this.width})
      : super(key: key);

  final String? text;
  final Widget? widget;
  final Function()? onPressed;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width ?? double.infinity,
        height: height ?? 40,
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          color: ColorResources.appMainColor,
          onPressed: onPressed ??
              () {
                print("Button Pressed");
              },
          child: widget ?? Text(text ?? "Click Me"),
        ));
  }
}
