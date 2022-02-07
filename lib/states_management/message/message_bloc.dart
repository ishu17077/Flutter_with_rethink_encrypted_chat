// ignore_for_file: implementation_imports, import_of_legacy_library_into_null_safe

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
  late StreamSubscription _subscription;

  MessageBloc(this._messageService) : super(MessageState.initial());

  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    if (event is Subscribed) { 
      await _subscription?.cancel();
      _subscription = _messageService
          .message(activeUser: event.user)
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
    _subscription.cancel();
    _messageService.dispose();
    return super.close();
  }
}
