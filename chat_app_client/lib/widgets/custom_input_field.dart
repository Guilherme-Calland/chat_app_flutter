import 'package:chat_app_client/misc/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../resources/resources.dart';

class CustomInputField extends StatelessWidget {
  final String? leadingText;
  final bool? autofocus;
  final bool? obscureText;
  final txtController = TextEditingController();
  final Function(String)? callback;
  CustomInputField({this.leadingText, this.autofocus, this.obscureText, this.callback});

  @override
  Widget build(BuildContext buildContext) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(
            '$leadingText:',
            style: TextStyle(
              color: white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
        ),
        Container(
          width: screenWidth(buildContext)/2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4), color: Colors.white),
          padding: EdgeInsets.only(left: 8),
          child: TextField(
            obscureText: obscureText ?? false,
            onChanged: callback,
            autofocus: autofocus ?? false,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
