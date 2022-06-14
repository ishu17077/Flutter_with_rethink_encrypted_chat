// @dart=2.9
import 'package:chat/src/models/user.dart';
import 'package:chat/src/models/message.dart';
import 'package:chat/src/services/message/message_service_contract.dart';
import 'package:flutter_with_rethink_encrypted_app/states_management/message/message_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FakeMessageService extends Mock implements IMessageService {}

void main() {
  MessageBloc sut;
  IMessageService messageService;
  User user;

  setUp(() {
    messageService = FakeMessageService();
    user = User(
      active: true,
      lastseen: DateTime.now(),
      photoUrl: '',
      username: 'test',
    );
    sut = MessageBloc(messageService);
  });
  tearDown(() {
    sut.close();
  });

  test('should emit initial only without subscriptions', () {
    expect(sut.state, MessageInitial());
  });

  test('should emit message sent state when message is sent', () async {
    final message = Message(
      from: '123',
      to: '456',
      contents: 'test message',
      timestamp: DateTime.now(),
    );

    when(messageService.send(message)).thenAnswer((_) async => null);
    sut.add(MessageEvent.onMessageSent(message));
    expectLater(await sut.stream.first, MessageState.sent(null));
  });
  test('should emit messages recieved from service', () {
    final message = Message(
      from: '123',
      to: '456',
      contents: 'test message',
      timestamp: DateTime.now(),
    );
    when(messageService.messages(activeUser: anyNamed('activeUser')))
        //? anyNamed essencially stands anyNamed parameter activeUser: any
        .thenAnswer((_) => Stream.fromIterable([message]));

    sut.add(MessageEvent.onSubscribed(user));
    //* expectLater(sut.stream, emits(MessageState.received(message))); //Try executing commented code, all run
    //* expectLater(sut.stream, emitsInOrder([MessageState.received(message)]));
    expectLater(sut.stream, emitsInOrder([MessageReceivedSuccess(message)]));
  });
}
