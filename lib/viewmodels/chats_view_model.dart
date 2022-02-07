//@dart= 2.9
// ignore_for_file: import_of_legacy_library_into_null_safe, implementation_imports

import 'package:chat/src/models/message.dart';
import 'package:chat/src/models/receipt.dart';
import 'package:flutter_firebase_chat_app/data/datasources/datasource_contract.dart';
import 'package:flutter_firebase_chat_app/models/chat.dart';
import 'package:flutter_firebase_chat_app/models/local_message.dart';
import 'package:flutter_firebase_chat_app/viewmodels/base_view_model.dart';

class ChatsViewModel extends BaseViewModel {
  final IDataSource _dataSource;
  ChatsViewModel(this._dataSource) : super(_dataSource);

  Future<void> receivedMessage(Message message) async {
    LocalMessage localMessage =
        LocalMessage(message.from, message, ReceiptStatus.delievered);
    await addMessage(localMessage);
  }

  Future<List<Chat>> getChats() async => await _dataSource.findAllChats();
}
