// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/foundation.dart';
import 'package:flutter_with_rethink_encrypted_app/data/datasources/datasource_contract.dart';
import 'package:flutter_with_rethink_encrypted_app/models/chat.dart';
import 'package:flutter_with_rethink_encrypted_app/models/local_message.dart';

abstract class BaseViewModel {
  final IDatasource _datasource;

  BaseViewModel(this._datasource);

  @protected
  Future<void> addMessage(LocalMessage message) async {
    if (!await _isExistingChat(message.chatId)) {
      await _createNewChat(message.chatId);
    }
    await _datasource.addMessage(message);
  }

  Future<bool> _isExistingChat(String chatId) async {
    // ignore: unnecessary_null_comparison
    return await _datasource.findChat(chatId) != null;
  }

  Future<void> _createNewChat(String chatId) async {
    final chat = Chat(chatId);
    await _datasource.addChat(chat);
  }
}
