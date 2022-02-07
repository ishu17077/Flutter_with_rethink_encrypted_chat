// ignore_for_file: implementation_imports, import_of_legacy_library_into_null_safe
// @dart=2.9
import 'dart:async';

import 'package:chat/src/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:chat/src/models/message.dart';

import 'package:bloc/bloc.dart';
import 'package:chat/src/services/message/message_service_contract.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final IMessageService _messageService;
  StreamSubscription _subscription;

  MessageBloc(this._messageService) : super(MessageState.initial());

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    if (event is Subscribed) {
      await _subscription?.cancel();
      _subscription = _messageService
          .messages(activeUser: event.user)
          .listen((message) => add(_MessageReceived(message)));
    }

    if (event is _MessageReceived) {
      yield MessageState.received(event.message);
    }
    if (event is MessageSent) {
      await _messageService.send(event.message);
      yield MessageState.sent(event.message);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _messageService.dispose();
    return super.close();
  }
}
//? super is used to call the constructor of the base class which is Bloc<... , ...> here MessageState.initial() is called to represent that it should be called to initially represent the data, see message_bloc_test.dart file
 //? Follow the if statement carefully if MessageEvent event is in subscribed state then event.user is asked as Subscribe state has a constructor to ask for a user
  //* if we think that a subscription has been made with a stream with different user, we can essencially just cancel that and make a new subscription with current user