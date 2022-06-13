// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_with_rethink_encrypted_app/colors.dart';
import 'package:flutter_with_rethink_encrypted_app/models/local_message.dart';
import 'package:flutter_with_rethink_encrypted_app/theme.dart';
import 'package:intl/intl.dart';

class ReceiverMessage extends StatelessWidget {
  final LocalMessage _message;
  final String _profileUrl;
  const ReceiverMessage(this._message, this._profileUrl);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.topLeft,
      widthFactor: 0.75, //? No wider than 75% of the device
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: isLightTheme(context) ? kBubbleLight : kBubbleDark,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  position: DecorationPosition.background,
                  //? Should be rendered as the background of its child
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                    child: Text(
                      _message.message.contents.trim(),
                      softWrap: true,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          ?.copyWith(height: 1.2),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12.0, left: 12.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      DateFormat('hh:mm a').format(_message.message.timestamp),
                      style: Theme.of(context).textTheme.overline?.copyWith(
                          color: isLightTheme(context)
                              ? Colors.black54
                              : Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            backgroundColor:
                isLightTheme(context) ? Colors.white : Colors.black,
            radius: 18.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.network(_profileUrl,
                  width: 30, height: 30, fit: BoxFit.fill),
            ),
          ),
        ],
      ),
    );
  }
}
