import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';
import '../navigation/navigation_helper.dart';
import '../resources/resources.dart';
import '../shared/chat_app_shared_data.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/disconnected_message.dart';

class LogInScreen extends StatelessWidget {
  static const ROUTE_ID = 'log_in_screen';
  late String userName = '';
  late String password = '';
  late NavigatorHelper nav;

  @override
  Widget build(BuildContext buildContext) {
    nav = NavigatorHelper(buildContext);

    return Consumer<ChatAppSharedData>(
      builder: (_, data, __){
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff000000),
            leading: GestureDetector(
              onTap: () {
                nav.pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: white,
              ),
            ),
          ),
          body: data.isSocketConnected() ?
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                margin: EdgeInsets.only(bottom: 64),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: darkBlue,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      'Log In',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    CustomInputField(
                      leadingText: 'UserName',
                      autofocus: true,
                      callback: updateUserName,
                    ),
                    CustomInputField(
                        leadingText: 'Password',
                        callback: updatePassword,
                        obscureText: true
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    CustomButton(
                      text: 'Confirm',
                      color: darkestBlue,
                      onPressed: () {
                        if(userName.isNotEmpty && password.isNotEmpty){
                          logIn(User(userName, password), data);
                        }
                      },
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      margin: EdgeInsets.all(0),
                    )
                  ],
                ),
              ),
            ),
          ):
          DisconnectedMessage(),
        );
      },
    );
  }

  void updateUserName(String userName) {
    this.userName = userName;
  }

  void updatePassword(String password) {
    this.password = password;
  }

  void logIn(User user, ChatAppSharedData sharedData) {
    sharedData.logIn(user);
    sharedData.changeCurrentUser(user);
  }
}
