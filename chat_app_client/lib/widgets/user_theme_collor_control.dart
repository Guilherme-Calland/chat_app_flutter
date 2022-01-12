import 'package:chat_app_client/shared/chat_app_shared_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../resources/resources.dart';
import 'brush_button.dart';
import 'color_box.dart';

class UserThemeColorControl extends StatelessWidget {
  UserThemeColorControl();
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatAppSharedData>(
      builder: (_, data, __){
        return Container(
          child: !data.colorOptionsEnabled
              ? Container(
            margin: const EdgeInsets.only(right: 16),
            child: BrushButton(
              onTap: () => data.showColorOptions(),
            ),
          )
              : Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                child: BrushButton(
                  onTap: () => data.hideColorOptions(),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ColorBox(theme: 'blue'),
                      ColorBox(theme: 'purple'),
                      ColorBox(theme: 'pink'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ColorBox(theme: 'red'),
                      ColorBox(theme: 'orange'),
                      ColorBox(theme: 'green'),
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
