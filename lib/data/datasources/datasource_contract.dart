// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_firebase_chat_app/models/chat.dart';
import 'package:flutter_firebase_chat_app/models/local_message.dart';

abstract class IDataSource {
  Future<void> addChat(Chat chat);
  Future<void> addMessage(LocalMessage message);
  Future<Chat> findChat(String chatId);
  Future<List<Chat>> findAllChats();
  Future<void> updateMessage(LocalMessage message);
  Future<List<LocalMessage>> findMessages(String chatId);
  Future<void> deleteChat(String chatId);
}
