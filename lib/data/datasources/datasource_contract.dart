// ignore_for_file: import_of_legacy_library_into_null_safe, implementation_imports

import 'package:chat/chat.dart';
import 'package:flutter_with_rethink_encrypted_app/models/chat.dart';
import 'package:flutter_with_rethink_encrypted_app/models/local_message.dart';

abstract class IDatasource {
  Future<void> addChat(Chat chat);
  Future<void> addMessage(LocalMessage message);
  Future<Chat> findChat(String chatId);
  Future<List<Chat>> findAllChats();
  Future<void> updateMessage(LocalMessage message);
  Future<List<LocalMessage>> findMessages(String chatId);
  Future<void> deleteChat(String chatId);
  Future<void> updateMessageReceipt(String messageId, ReceiptStatus status);
}
