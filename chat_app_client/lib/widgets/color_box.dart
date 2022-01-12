import 'package:flutter/material.dart';
import '../resources/resources.dart';

class ColorBox extends StatelessWidget {
  Color color;

  ColorBox({required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: white)
      ),
      width: 15,
      height: 15,
    );
  }
}
