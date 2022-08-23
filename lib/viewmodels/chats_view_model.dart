//@dart=2.9

import 'package:chat/chat.dart';
import 'package:flutter_with_rethink_encrypted_app/data/datasources/datasource_contract.dart';
import 'package:flutter_with_rethink_encrypted_app/models/chat.dart';
import 'package:flutter_with_rethink_encrypted_app/models/local_message.dart';
import 'package:flutter_with_rethink_encrypted_app/viewmodels/base_view_model.dart';

class ChatsViewModel extends BaseViewModel {
  final IDatasource _datasource;
  IUserService userService;

  ChatsViewModel(this._datasource, {this.userService}) : super(_datasource);

  Future<List<Chat>> getChats() async {
    final chats = await _datasource.findAllChats();
    if (userService != null) {
      await Future.forEach(chats, (Chat chat) async {
        final user = await userService.fetch(chat.id);
        chat.from = user;
      });
    }

    return chats;
  }

  Future<void> receivedMessage(Message message) async {
    LocalMessage localMessage =
        LocalMessage(message.from, message, ReceiptStatus.delivered);
    await addMessage(localMessage);
  }
}
