//@dart=2.9

import 'package:chat/src/models/message.dart';
import 'package:flutter_with_rethink_encrypted_app/data/datasources/datasource_contract.dart';
import 'package:flutter_with_rethink_encrypted_app/models/chat.dart';
import 'package:flutter_with_rethink_encrypted_app/viewmodels/chats_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataSource extends Mock implements IDatasource {}

void main() {
  ChatsViewModel sut;
  MockDataSource mockDataSource;


  setUp(() {
    mockDataSource = MockDataSource();
    sut = ChatsViewModel(mockDataSource);
  });
  final message = Message.fromJson({
    'from': '111',
    'to': '222',
    'contents': 'hey',
    'timestamp': DateTime.parse("2022-01-17"),
    'id': '4444'
  });
  test('initial chats return empty list', () async {
    //? I am asking Mockito below that wheneber findAllChats method is called return an empty array []
    when(mockDataSource.findAllChats()).thenAnswer((_) async => []);
    //* getchat method is calling findAllChats(), you can check
    expect(await sut.getChats(), isEmpty);
  });
  test('chats return a single chat item', () async {
    final chat = Chat('123');
    when(mockDataSource.findAllChats()).thenAnswer((_) async => [chat]);
    //* getchat method is calling findAllChats(), you can check
    final chats = await sut.getChats();
    expect(chats, isNotEmpty);
  });
  test('create a new chat on recieving a message for the first time', () async {
    when(mockDataSource.findChat(any)).thenAnswer((_) async => null);
    await sut.receivedMessage(message);
    //? Veryfying that our addMessage() was only called once with sut.recievedMessage(....)
    verify(mockDataSource.addMessage(any)).called(1);
  });
  test('add new message to existing chat', () async {
    final chat = Chat('123');

    when(mockDataSource.findChat(any)).thenAnswer((_) async => chat);
    await sut.receivedMessage(message);
    //? We are veryfying that we never called addChat function as we are adding message to an existing chat
    verifyNever(mockDataSource.addChat(any));
    verify(mockDataSource.addMessage(any)).called(1);
  });
}
