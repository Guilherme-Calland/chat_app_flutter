import 'package:chat_app_client/resources/resources.dart';
import 'package:chat_app_client/shared/chat_app_shared_data.dart';
import 'package:chat_app_client/widgets/custom_button.dart';
import 'package:chat_app_client/widgets/disconnected_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../misc/utils.dart';
import '../model/user.dart';
import '../navigation/navigation_helper.dart';

class RegistrationScreen extends StatelessWidget {
  static const String SIGN_UP_ROUTE_ID = 'sign_up_screen';
  static const String LOG_IN_ROUTE_ID = 'log_in_screen';
  String signUpOrLogIn;
  String userName = '';
  String password = '';
  late NavigatorHelper nav;
  var userNameNode = FocusNode();
  var passwordNode = FocusNode();
  var userNameTxtController = TextEditingController();
  var passwordTxtController = TextEditingController();

  RegistrationScreen(this.signUpOrLogIn);

  @override
  Widget build(BuildContext buildContext) {
    nav = NavigatorHelper(buildContext);

    return Consumer<ChatAppSharedData>(
      builder: (_, data, __) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
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
          body: data.isSocketConnected()
              ? Center(
                  child: SingleChildScrollView(
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      margin: const EdgeInsets.only(bottom: 64),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: signUpOrLogIn == 'Sign Up' ? blue : darkBlue,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            signUpOrLogIn,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 32),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'User name:',
                                style: TextStyle(
                                  color: white.withOpacity(0.7),
                                  fontSize: 16,
                                ),
                              ),
                              Container(
                                width: screenWidth(buildContext) / 2,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.white),
                                padding: const EdgeInsets.only(left: 8),
                                child: TextField(
                                  controller: userNameTxtController,
                                  textInputAction: TextInputAction.none,
                                  focusNode: userNameNode,
                                  onSubmitted: (text) {
                                    goToNextField();
                                  },
                                  onChanged: updateUserName,
                                  autofocus: true,
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Password:',
                                style: TextStyle(
                                  color: white.withOpacity(0.7),
                                  fontSize: 16,
                                ),
                              ),
                              Container(
                                width: screenWidth(buildContext) / 2,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.white),
                                padding: const EdgeInsets.only(left: 8),
                                child: TextField(
                                  controller: passwordTxtController,
                                  obscureText: true,
                                  textInputAction: TextInputAction.none,
                                  focusNode: passwordNode,
                                  onSubmitted: (text) {
                                    registerAndOrLog(data);
                                  },
                                  onChanged: updatePassword,
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          CustomButton(
                            text: 'Confirm',
                            color: signUpOrLogIn == 'Sign Up'
                                ? darkBlue
                                : darkestBlue,
                            onPressed: () {
                              registerAndOrLog(data);
                            },
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            margin: EdgeInsets.all(0),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : DisconnectedMessage(),
        );
      },
    );
  }

  void registerAndOrLog(ChatAppSharedData data) {
    if (userName.isNotEmpty && password.isNotEmpty) {
      User user = User(userName, password);
      signUpOrLogIn == 'Sign Up'
          ? data.signUp(user)
          : data.logIn(user);
      data.changeCurrentUser(user);
      userNameNode.requestFocus();
      userNameTxtController.clear();
      passwordTxtController.clear();
    }
  }

  void updateUserName(String userName) {
    this.userName = userName;
  }

  void updatePassword(String password) {
    this.password = password;
  }

  void goToNextField() {
    passwordNode.requestFocus();
  }
}
