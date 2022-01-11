import 'package:chat_app_client/screens/chat_screen.dart';
import '../screens/home_screen.dart';
import '../screens/registration_screen.dart';

class Routes{
  static routes() {
    return {
      HomeScreen.ROUTE_ID: (buildContext) => HomeScreen(),
      RegistrationScreen.SIGN_UP_ROUTE_ID: (buildContext) => RegistrationScreen('Sign Up'),
      RegistrationScreen.LOG_IN_ROUTE_ID: (buildContext) => RegistrationScreen('Log in'),
      ChatScreen.ROUTE_ID: (buildContext) => ChatScreen()
    };
  }

  static initScreen(){
    return HomeScreen.ROUTE_ID;
  }
}