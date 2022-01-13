import 'package:chat_app_client/shared/chat_app_shared_data.dart';
import 'package:chat_app_client/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../misc/utils.dart';
import '../resources/resources.dart';

class DisconnectedMessage extends StatelessWidget {
  final txtEditController = TextEditingController();
  final ChatAppSharedData sharedData;
  DisconnectedMessage(this.sharedData);

  @override
  Widget build(BuildContext buildContext) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.warning,
            color: Colors.orange,
            size: 48,
          ),
          const SizedBox(
            height: 16,
          ),
          const Text('No connection to Server.',
              style: TextStyle(fontSize: 24)),
          const SizedBox(
            height: 32,
          ),
          Text(
            'Copy your local server IP address here.',
            style: TextStyle(fontSize: 12, color: white.withOpacity(0.7)),
          ),
          const SizedBox(
            height: 4,
          ),
          Container(
            width: screenWidth(buildContext) / 2,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4), color: Colors.white),
            padding: const EdgeInsets.only(left: 8),
            child: TextField(
              controller: txtEditController,
              textAlign: TextAlign.center,
              textInputAction: TextInputAction.none,
              onSubmitted: (text) => submitIPAddress(text),
              keyboardType: TextInputType.visiblePassword,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          CustomButton(
            onPressed: () => submitIPAddress(txtEditController.text),
            text: 'Ok',
            color: white.withOpacity(0.2),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            wrapContent: true,
          )
        ],
      ),
    );
  }

  void submitIPAddress(text){
    sharedData.passServerIP(text);
    txtEditController.clear();
  }
}
