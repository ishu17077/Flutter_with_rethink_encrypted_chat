// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:bloc/bloc.dart';
import 'package:flutter_with_rethink_encrypted_app/models/local_message.dart';
import 'package:flutter_with_rethink_encrypted_app/viewmodels/chat_view_model.dart';

class MessageThreadCubit extends Cubit<List<LocalMessage>> {
  final ChatViewModel viewModel;
  MessageThreadCubit(this.viewModel) : super([]);
  Future<void> messages(String chatId) async {
    final messages = await viewModel.getMessages(chatId);
    emit(messages);
  }
}
