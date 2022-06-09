//@dart = 2.9
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_app/composition_root.dart';
import 'package:flutter_firebase_chat_app/theme.dart';
import 'package:flutter_firebase_chat_app/ui/pages/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CompositionRoot
      .configure(); //? We need to insure the widgetbindingisInitialixed because there is an await function some native code which may hinder the threads to run our app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: lightTheme(context),
      debugShowCheckedModeBanner: false,
      darkTheme: darkTheme(context),
      home: CompositionRoot.composeHomeUi(),
    );
  }
}
