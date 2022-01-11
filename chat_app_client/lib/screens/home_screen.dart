import 'package:chat_app_client/resources/resources.dart';
import 'package:chat_app_client/screens/log_in_screen.dart';
import 'package:chat_app_client/screens/sign_up_screen.dart';
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
                Text(
                  'Chat App',
                  style: TextStyle(fontSize: 56),
                ),
                SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButton(
                      text: 'Sign Up',
                      color: blue,
                      onPressed: () {
                        nav.push(SignUpScreen.ROUTE_ID);
                      },
                    ),
                    CustomButton(
                      text: 'Log In',
                      color: darkBlue,
                      onPressed: () {
                        nav.push(LogInScreen.ROUTE_ID);
                      },
                    ),
                  ],
                )
              ],
            ),
          ):
          DisconnectedMessage()
          ,
        );
      },
    );
  }
}
