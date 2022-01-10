import 'package:flutter/material.dart';

import '../resources/resources.dart';

class CustomButton extends StatelessWidget {
  final Color? color;
  final String text;
  final Function()? onPressed;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  CustomButton({required this.text, this.color, this.onPressed, this.padding, this.margin});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color ?? green,
        ),
        padding: padding ?? EdgeInsets.symmetric(
          horizontal: 60,
          vertical: 20,
        ),
        margin: margin ?? EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 10,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: white
          ),
        ),
      ),
    );
  }
}
