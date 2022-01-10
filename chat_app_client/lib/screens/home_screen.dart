import 'package:chat_app_client/resources/resources.dart';
import 'package:chat_app_client/screens/log_in_screen.dart';
import 'package:chat_app_client/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  static const String ROUTE_ID = 'home_screen';

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      body: Center(
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
                    Navigator.pushNamed(
                      buildContext,
                      SignUpScreen.ROUTE_ID,
                    );
                  },
                ),
                CustomButton(
                  text: 'Log In',
                  color: darkBlue,
                  onPressed: () {
                    Navigator.pushNamed(
                      buildContext,
                      LogInScreen.ROUTE_ID,
                    );
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

