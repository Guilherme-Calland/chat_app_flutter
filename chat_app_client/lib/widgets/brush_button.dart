import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrushButton extends StatelessWidget {
  Function() onTap;
  BrushButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        Icons.brush,
        color: Colors.white,
      ),
    );
  }
}
