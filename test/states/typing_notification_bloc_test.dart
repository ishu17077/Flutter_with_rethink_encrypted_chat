//@dart = 2.9

import 'package:chat/src/models/typing_event.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/typing/typing_notification_service_contract.dart';
import 'package:flutter_with_rethink_encrypted_app/states_management/typing/typing_notification_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FakeTypingService extends Mock implements ITypingNotification {}

void main() {
  TypingNotificationBloc sut;
  ITypingNotification typingNotification;
  User user;
  List<String> userWithChatId;
  setUp(() {
    typingNotification = FakeTypingService();
    user = User(
      active: true,
      lastseen: DateTime.now(),
      photoUrl: '',
      username: 'test',
    );
    userWithChatId = ['123', '234', '345'];
    sut = TypingNotificationBloc(typingNotification);
  });
  tearDown(() {
    sut.close();
  });
  test('should emit ininitial state without subscription', () {
    expect(sut.state, TypingNotificationInitial());
  });
  test('should emit a typing sent event', () {
    final typingEvent = TypingEvent(
      event: Typing.start,
      from: '123',
      to: '345',
    );
    when(typingNotification.send(event: typingEvent))
        .thenAnswer((_) async => null);
    sut.add(TypingNotificationEvent.onTypingSent(typingEvent));
    expectLater(sut.stream, emits(TypingNotificationSentSuccess()));
  });
  test('should emit receipts recieved from service', () {
    final typingEvent = TypingEvent(
      event: Typing.start,
      from: '123',
      to: '345',
    );
    when(typingNotification.subscribe(any, any))
        .thenAnswer((_) => Stream.fromIterable([typingEvent]));

    sut.add(TypingNotificationEvent.onSubscribed(user,
        userWithChat: userWithChatId));
    expectLater(sut.stream,
        emitsInOrder([TypingNotificationReceivedSuccess(typingEvent)]));
  });
}
