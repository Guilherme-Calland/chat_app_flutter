import 'package:chat_app_client/resources/resources.dart';
import 'package:chat_app_client/shared/chat_app_shared_data.dart';
import 'package:chat_app_client/widgets/custom_button.dart';
import 'package:chat_app_client/widgets/disconnected_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_input_field.dart';

class SignUpScreen extends StatelessWidget {
  static const String ROUTE_ID = 'sign_up_screen';
  late var providerData;
  late String userName;
  late String password;

  @override
  Widget build(BuildContext buildContext) {
    providerData = Provider.of<ChatAppSharedData>(buildContext, listen: false);
    providerData.initializeConnector(buildContext);

    return Consumer<ChatAppSharedData>(
      builder: (_, data, __){
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff000000),
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(buildContext);
              },
              child: Icon(
                Icons.arrow_back,
                color: white,
              ),
            ),
          ),
          body: data.isSocketConnected() ?
          SingleChildScrollView(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                margin: EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: blue,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      'Sign Up',
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
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    CustomButton(
                      text: 'Confirm',
                      color: darkBlue,
                      onPressed: () {
                        if(userName.isNotEmpty && password.isNotEmpty){
                          registerUser(userName, password);
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
          DisconnectedMessage()
          ,
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

  void registerUser(String userName, String password) {

  }
}
