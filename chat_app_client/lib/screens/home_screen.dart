import 'package:chat_app_client/resources/resources.dart';
import 'package:chat_app_client/screens/registration_screen.dart';
import 'package:chat_app_client/widgets/disconnected_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../navigation/navigation_helper.dart';
import '../shared/chat_app_shared_data.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  static const String ROUTE_ID = 'home_screen';
  late var sharedData;
  late NavigatorHelper nav;

  @override
  Widget build(BuildContext buildContext) {
    sharedData = Provider.of<ChatAppSharedData>(buildContext, listen: false);
    sharedData.initializeConnector(buildContext);
    nav = NavigatorHelper(buildContext);

    return Consumer<ChatAppSharedData>(
      builder: (_, data, __){
        return Scaffold(
          body: data.isSocketConnected() ?
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Chat App',
                  style: TextStyle(fontSize: 56),
                ),
                const SizedBox(
                  height: 32,
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
          ):
          DisconnectedMessage(),
        );
      },
    );
  }
}
