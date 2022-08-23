//@dart = 2.9
// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_with_rethink_encrypted_app/composition_root.dart';
import 'package:flutter_with_rethink_encrypted_app/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CompositionRoot.configure();
  //? We need to insure the widgetbindingisInitialixed because there is an await function some native code which may hinder the threads to run our app
  final firstPage = CompositionRoot.start();
  runApp(MyApp(firstPage));
}

class MyApp extends StatelessWidget {
  final Widget firstPage;
  // ignore: prefer_const_constructors_in_immutables
  MyApp(this.firstPage);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: lightTheme(context),
      debugShowCheckedModeBanner: false,
      darkTheme: darkTheme(context),
      home: firstPage,
    );
  }
}
