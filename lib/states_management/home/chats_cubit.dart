// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:bloc/bloc.dart';

import 'package:flutter_with_rethink_encrypted_app/models/chat.dart';
import 'package:flutter_with_rethink_encrypted_app/viewmodels/chats_view_model.dart';

class ChatsCubit extends Cubit<List<Chat>> {
  final ChatsViewModel viewModel;
  ChatsCubit(this.viewModel) : super([]);
  Future<void> chats() async {
    final chats = await viewModel.getChats();
    emit(chats);
  }
}
