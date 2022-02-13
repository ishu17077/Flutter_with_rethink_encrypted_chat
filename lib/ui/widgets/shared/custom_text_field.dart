// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_app/colors.dart';
import 'package:flutter_firebase_chat_app/theme.dart';

// ignore: use_key_in_widget_constructors
class CustomTextField extends StatelessWidget {
  final String hint;
  final Function(String val) onChanged;
  final double height;
  final TextInputAction inputAction;

  // ignore: use_key_in_widget_constructors
  const CustomTextField({
    this.hint,
    this.onChanged,
    this.inputAction,
    this.height = 54.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        keyboardType: TextInputType.text,
        onChanged: onChanged,
        textInputAction: inputAction,
        cursorColor: kPrimary,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            // bottom: 8.0,
          ),
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
      decoration: BoxDecoration(
        color: isLightTheme(context) ? Colors.white : kBubbleDark,
        border: Border.all(
          color: isLightTheme(context)
              ? const Color(0xFFC4C4C4)
              : const Color(0xFF393737),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(45.0),
      ),
    );
  }
}
