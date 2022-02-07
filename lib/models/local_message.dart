//@dart = 2.9
// ignore_for_file: implementation_imports

import 'package:chat/src/models/message.dart';
import 'package:chat/src/models/receipt.dart';

class LocalMessage {
  String chatId;
  String get id => _id;
  String _id;
  Message message;
  ReceiptStatus receipt;

  LocalMessage(this.chatId, this.message, this.receipt);

  Map<String, dynamic> toMap() => {
        'chat_id': chatId,
        'id': message.id,
        ...message.toJson(),
        //? ... spread opeator
        'receipt': receipt.value(),
      };

  factory LocalMessage.fromMap(Map<String, dynamic> json) {
    final message = Message(
      from: json['from'],
      to: json['to'],
      contents: json['contents'],
      timestamp: json['timestamp'],
    );
    final localMessage = LocalMessage(
        json['chat_id'], message, EnumParsing.fromString(json['receipt']));
    localMessage._id = json['id'];
    return localMessage;
  }
}
