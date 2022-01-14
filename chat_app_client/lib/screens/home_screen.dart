import 'package:chat_app_client/misc/utils.dart';
import 'package:chat_app_client/resources/resources.dart';
import 'package:chat_app_client/screens/registration_screen.dart';
import 'package:chat_app_client/widgets/disconnected_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../navigation/navigation_helper.dart';
import '../shared/chat_app_shared_data.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  static const String ROUTE_ID = 'home_screen';
  late NavigatorHelper nav;

  @override
  Widget build(BuildContext buildContext) {
    nav = NavigatorHelper(buildContext);
    return Consumer<ChatAppSharedData>(
      builder: (buildContext, data, __) {
        data.initializeConnector(buildContext);
        return Scaffold(
          body: data.socketStatus == 'connected'
              ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedTextKit(
                  totalRepeatCount: 1,
                  animatedTexts: [
                    TyperAnimatedText('',
                      speed: const Duration(milliseconds: 100),
                      textStyle: TextStyle(
                        fontSize: screenWidth(buildContext)*0.13
                      )
                    ),
                    TyperAnimatedText(
                      'Cool Chat',
                      speed: const Duration(milliseconds: 200),
                      textStyle: TextStyle(
                          color: white,
                          fontSize: screenWidth(buildContext)*0.13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          wordSpacing: 4),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButton(
                      text: 'Sign Up',
                      color: blue,
                      onPressed: () {
                        nav.push(RegistrationScreen.SIGN_UP_ROUTE_ID);
                      },
                    ),
                    CustomButton(
                      text: 'Log in',
                      color: darkBlue,
                      onPressed: () {
                        nav.push(RegistrationScreen.LOG_IN_ROUTE_ID);
                      },
                    ),
                  ],
                )
              ],
            ),
          )
              : DisconnectedMessage(data),
        );
      },
    );
  }
}