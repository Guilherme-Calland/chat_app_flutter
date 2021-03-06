import 'package:chat_app_client/resources/resources.dart';
import 'package:chat_app_client/shared/chat_app_shared_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'navigation/routes.dart';

void main() async{
  await ajustScreenOrientation();
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(_) {
    return ChangeNotifierProvider(
      create: (context) => ChatAppSharedData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cool Chat',
        theme: ThemeData(
          primaryColor: black,
          scaffoldBackgroundColor: black,
          textTheme: TextTheme(
            bodyText2: GoogleFonts.varelaRound(
                color: white
            ),
          ),
        ),
        routes: Routes.routes(),
        initialRoute: Routes.initScreen(),
      ),
    );
  }
}

Future<void> ajustScreenOrientation() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]
  );
}