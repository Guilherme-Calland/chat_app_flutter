import 'package:chat_app_client/shared/chat_app_shared_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../resources/resources.dart';
import 'brush_button.dart';
import 'color_box.dart';

class UserThemeColorControl extends StatelessWidget {
  Function() callback;

  UserThemeColorControl({required this.callback});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatAppSharedData>(
      builder: (_, data, __){
        return Container(
          child: !data.colorOptionsEnabled
              ? Container(
            margin: const EdgeInsets.only(right: 16),
            child: BrushButton(
              onTap: (){
                data.toggleColorOptions();
                callback();
              },
            ),
          )
              : Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                child: BrushButton(
                  onTap: (){
                    data.toggleColorOptions();
                    callback();
                  },
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ColorBox(theme: 'blue', callback: callback),
                      ColorBox(theme: 'purple', callback: callback),
                      ColorBox(theme: 'pink', callback: callback),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ColorBox(theme: 'red', callback: callback),
                      ColorBox(theme: 'orange', callback: callback),
                      ColorBox(theme: 'green', callback: callback),
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      },
    );

  }
}
