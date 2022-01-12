import 'package:chat_app_client/misc/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../resources/resources.dart';
import '../shared/chat_app_shared_data.dart';

class ColorBox extends StatelessWidget {
  String theme;
  ColorBox({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatAppSharedData>(
      builder: (_, data, __) {
        return GestureDetector(
          onTap: () {
            data.changeCurrentUserTheme(theme);
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: themeToColor(theme),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: data.currentUser.theme == theme
                    ? white
                    : white.withOpacity(0.5),
              ),
            ),
            width: 15,
            height: 15,
          ),
        );
      },
    );
  }
}
