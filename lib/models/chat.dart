//@dart = 2.9

import 'package:chat/chat.dart';
import 'package:flutter_with_rethink_encrypted_app/models/local_message.dart';

class Chat {
  String id;
  int unread = 0;
  List<LocalMessage> messages = [];
  LocalMessage mostRecent;
  User from;
  Chat(this.id, {this.messages, this.mostRecent});

  toMap() => {'id': id};
  factory Chat.fromMap(Map<String, dynamic> json) => Chat(json['id']);
}
