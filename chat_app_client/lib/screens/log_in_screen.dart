import 'package:flutter/material.dart';

import '../resources/resources.dart';

class LogInScreen extends StatelessWidget {
  static const String ROUTE_ID = 'log_in_screen';

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Log In',
          style: TextStyle(fontSize: 24),
        ),
        backgroundColor: darkBlue,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(buildContext);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Text('LogInScreen'),
      ),
    );
  }
}
