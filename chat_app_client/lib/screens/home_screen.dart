import 'package:chat_app_client/resources/resources.dart';
import 'package:chat_app_client/screens/log_in_screen.dart';
import 'package:chat_app_client/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';

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
              style: TextStyle(fontSize: 80),
            ),
            SizedBox(
              height: 64,
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

class CustomButton extends StatelessWidget {
  final Color? color;
  final String text;
  final Function()? onPressed;

  CustomButton({required this.text, this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color ?? green,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 80,
          vertical: 20,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 32),
        ),
      ),
    );
  }
}
