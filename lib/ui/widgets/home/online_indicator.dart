import 'package:flutter/material.dart';
import 'package:flutter_with_rethink_encrypted_app/colors.dart';
import 'package:flutter_with_rethink_encrypted_app/theme.dart';

class OnlineIndicator extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const OnlineIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15.0,
      width: 15.0,
      decoration: BoxDecoration(
          color: kIndicatorBubble,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            width: 3.0,
            color: isLightTheme(context) ? Colors.white : Colors.black,
          )),
    );
  }
}
