// @dart=2.9
// ignore: import_of_legacy_library_into_null_safe, implementation_imports
// ignore: import_of_legacy_library_into_null_safe, implementation_imports
// ignore_for_file: import_of_legacy_library_into_null_safe, implementation_imports, duplicate_ignore

part of 'typing_notification_bloc.dart';

abstract class TypingNotificationEvent extends Equatable {
  const TypingNotificationEvent();

  factory TypingNotificationEvent.onSubscribed(User user,
          {List<String> userWithChat}) =>
      Subscribed(user, userWithChat: userWithChat);

  factory TypingNotificationEvent.onTypingSent(TypingEvent event) =>
      TypingNotificationSent(event);

  @override
  List<Object> get props => [];
}

class Subscribed extends TypingNotificationEvent {
  final User user;
  final List<String> userWithChat;
  const Subscribed(this.user, {this.userWithChat});

  @override
  List<Object> get props => [user, userWithChat];
}

class NotSubscribed extends TypingNotificationEvent {
  //* will throw a TypingNotificationInitialState
}

class TypingNotificationSent extends TypingNotificationEvent {
  final TypingEvent event;
  const TypingNotificationSent(this.event);

  @override
  List<Object> get props => [event];
}

class _TypingNotificationReceived extends TypingNotificationEvent {
  const _TypingNotificationReceived(this.event);

  final TypingEvent event;

  @override
  List<Object> get props => [event];
}
