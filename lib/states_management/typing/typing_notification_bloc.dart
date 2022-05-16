// ignore_for_file: implementation_imports, import_of_legacy_library_into_null_safe
// @dart=2.9
import 'dart:async';

import 'package:chat/src/models/typing_event.dart';
import 'package:chat/src/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:chat/src/services/typing/typing_notification_service_contract.dart';

import 'package:bloc/bloc.dart';
part 'typing_notification_event.dart';
part 'typing_notification_state.dart';

class TypingNotificationBloc
    extends Bloc<TypingNotificationEvent, TypingNotificationState> {
  final ITypingNotification _typingService;
  StreamSubscription _subscription;

  TypingNotificationBloc(this._typingService)
      : super(TypingNotificationState.initial());

  @override
  Stream<TypingNotificationState> mapEventToState(
      // ignore: avoid_renaming_method_parameters
      TypingNotificationEvent typingEvent) async* {
    if (typingEvent is Subscribed) {
      if (typingEvent.userWithChat == null) {
        add(NotSubscribed());
        return;
      }
      await _subscription?.cancel();
      _subscription = _typingService
          .subscribe(typingEvent.user, typingEvent.userWithChat)
          .listen((event) => add(_TypingNotificationReceived(event)));
    }

    if (typingEvent is _TypingNotificationReceived) {
      yield TypingNotificationState.received(typingEvent.event);
    }
    if (typingEvent is TypingNotificationSent) {
      await _typingService.send(event: typingEvent.event);
      yield TypingNotificationState.sent();
    }
    if (typingEvent is NotSubscribed) {
      yield TypingNotificationState.initial();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _typingService.dispose();
    return super.close();
  }
}