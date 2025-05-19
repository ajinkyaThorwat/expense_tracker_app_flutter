import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const appId = 'ADD-YOUR-APP-ID-DERIVED-FROM-BACK4APP';
  const clientKey = 'ADD-YOUR-CLIENT-KEY';
  const serverUrl = 'https://parseapi.back4app.com';
// aws volt request, volt option in back4 app
  await Parse().initialize(appId, serverUrl, clientKey: clientKey, autoSendSessionId: true);

  runApp(MaterialApp(
    title: 'Expense Tracker',
    debugShowCheckedModeBanner: false,
    home: LoginScreen(),
  ));
}
