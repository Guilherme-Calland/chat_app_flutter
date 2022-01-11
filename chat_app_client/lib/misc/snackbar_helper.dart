import 'package:flutter/material.dart';

class SnackBarHelper {
  late BuildContext buildContext;

  SnackBarHelper(this.buildContext);

  display(String msg, Color color) {
    ScaffoldMessenger.of(buildContext).showSnackBar(
      SnackBar(
        content: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            msg,
            style: TextStyle(fontSize: 16),
          ),
        ),
        backgroundColor: color,
      ),
    );
  }
}
