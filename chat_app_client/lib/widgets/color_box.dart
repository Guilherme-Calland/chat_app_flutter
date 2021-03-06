import 'package:chat_app_client/misc/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../resources/resources.dart';
import '../shared/chat_app_shared_data.dart';

class ColorBox extends StatelessWidget {
  Function() callback;
  String theme;
  ColorBox({required this.callback, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatAppSharedData>(
      builder: (_, data, __) {
        return GestureDetector(
          onTap: (){
            callback();
            data.changeCurrentUserTheme(theme);
            data.toggleColorOptions();
          },
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: themeToColor(theme),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: data.currentUser.theme == theme
                    ? white
                    : white.withOpacity(0.5),
              ),
            ),
            width: 18,
            height: 18,
          ),
        );
      },
    );
  }
}
