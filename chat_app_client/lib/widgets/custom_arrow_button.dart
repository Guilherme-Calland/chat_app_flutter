import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../misc/utils.dart';
import '../resources/resources.dart';
import '../shared/chat_app_shared_data.dart';

class CustomArrowButton extends StatelessWidget {
  Function()? onPressed;
  CustomArrowButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatAppSharedData>(
      builder: (_, data, __){
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: themeToColor(data.currentUser.theme),
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              Icons.send,
              color: white,
            ),
          ),
        );
      },
    );

  }
}
