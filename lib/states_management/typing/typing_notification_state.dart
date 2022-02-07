// @dart=2.9
part of 'typing_notification_bloc.dart';

abstract class TypingNotificationState extends Equatable {
  const TypingNotificationState();
  factory TypingNotificationState.initial() => TypingNotificationInitial();
  factory TypingNotificationState.sent() => TypingNotificationSentSuccess();
  factory TypingNotificationState.received(TypingEvent event) =>
      TypingNotificationReceivedSuccess(event);

  @override
  List<Object> get props => [];
}

class TypingNotificationInitial extends TypingNotificationState {}

class TypingNotificationSentSuccess extends TypingNotificationState {
  // final Typing typing;
  // const TypingNotificationSentSuccess(this.typing);

  // @override
  // List<Object> get props => [typing];
  //? Since we do not need a confirmation to weather typing notification is sent or not so doesn't matter
}

class TypingNotificationReceivedSuccess extends TypingNotificationState {
  final TypingEvent event;
  const TypingNotificationReceivedSuccess(this.event);

  @override
  List<Object> get props => [event];
}
