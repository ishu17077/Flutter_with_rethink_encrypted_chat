//? For single chat opening
// ignore_for_file: import_of_legacy_library_into_null_safe, implementation_imports

import 'package:chat/chat.dart';
import 'package:flutter_with_rethink_encrypted_app/data/datasources/datasource_contract.dart';
import 'package:flutter_with_rethink_encrypted_app/models/local_message.dart';
import 'package:flutter_with_rethink_encrypted_app/viewmodels/base_view_model.dart';

class ChatViewModel extends BaseViewModel {
  final IDatasource _dataSource;
  String _chatId = '';
  String get chatId => _chatId;
  int otherMessages = 0;
  ChatViewModel(this._dataSource) : super(_dataSource);

  Future<List<LocalMessage>> getMessages(String chatId) async {
    final messages = await _dataSource.findMessages(chatId);
    if (messages.isNotEmpty) _chatId = chatId;
    return messages;
  }

  Future<void> sentMessage(Message message) async {
    LocalMessage localMessage =
        LocalMessage(message.to, message, ReceiptStatus.sent);
    if (_chatId.isNotEmpty) return await _dataSource.addMessage(localMessage);
    _chatId = localMessage.chatId;
    await addMessage(localMessage);
  }

  Future<void> recievedMessage(Message message) async {
    LocalMessage localMessage =
        LocalMessage(message.from, message, ReceiptStatus.delivered);
    //? The line below essencially means like if we are in a chat with suppose a person, then if a second person sends us a message then increase the count of othermessages by 1
    if (chatId.isEmpty) _chatId = localMessage.chatId;
    if (localMessage.chatId != _chatId) otherMessages++;
    await addMessage(localMessage);
  }

  Future<void> updateMessageReceipt(Receipt receipt) async {
    await _dataSource.updateMessageReceipt(receipt.messageId, receipt.status);
  }
}
