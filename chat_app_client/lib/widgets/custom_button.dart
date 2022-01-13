import 'package:chat_app_client/misc/utils.dart';
import 'package:flutter/material.dart';

import '../resources/resources.dart';

class CustomButton extends StatelessWidget {
  final Color? color;
  final String text;
  final Function()? onPressed;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool wrapContent;

  CustomButton({required this.text, this.color, this.onPressed, this.padding, this.margin, this.wrapContent = false});

  @override
  Widget build(BuildContext buildContext) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: wrapContent ? null : screenWidth(buildContext) * 0.45 ,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color ?? green,
        ),
        padding: padding ?? EdgeInsets.symmetric(
          vertical: 20,
        ),
        margin: margin ?? EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 10,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: white
          ),
        ),
      ),
    );
  }
}
