import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_with_rethink_encrypted_app/colors.dart';
import 'package:flutter_with_rethink_encrypted_app/models/local_message.dart';
import 'package:flutter_with_rethink_encrypted_app/theme.dart';
import 'package:intl/intl.dart';

class SenderMessage extends StatelessWidget {
  final LocalMessage _message;
  const SenderMessage(this._message);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerRight,
      widthFactor: 0.75, //? No wider than 75% of the device
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: kPrimary,
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
                          ?.copyWith(height: 1.2, color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12.0, left: 12.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
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
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: isLightTheme(context) ? Colors.white : Colors.black,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: _message.receipt == ReceiptStatus.read
                      ? Colors.green[700]
                      : Colors.grey,
                  size: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
