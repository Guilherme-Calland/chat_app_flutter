import 'package:chat_app_client/screens/log_in_screen.dart';

import '../screens/home_screen.dart';
import '../screens/sign_up_screen.dart';

class Routes{
  static routes() {
    return {
      HomeScreen.ROUTE_ID: (buildContext) => HomeScreen(),
      LogInScreen.ROUTE_ID: (buildContext) => LogInScreen(),
      SignUpScreen.ROUTE_ID: (buildContext) => SignUpScreen()
    };
  }

  static initScreen(){
    return HomeScreen.ROUTE_ID;
  }
}