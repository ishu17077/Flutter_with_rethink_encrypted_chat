import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/message/message_service_contract.dart';
import 'package:flutter_firebase_chat_app/states_management/message/message_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FakeMessageService extends Mock implements IMessageService {}

void main() {
  late MessageBloc sut;
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
}
