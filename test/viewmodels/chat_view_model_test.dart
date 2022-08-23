//@dart=2.9
import 'package:chat/src/models/receipt.dart';
import 'package:chat/src/models/message.dart';
import 'package:flutter_with_rethink_encrypted_app/data/datasources/datasource_contract.dart';
import 'package:flutter_with_rethink_encrypted_app/models/chat.dart';
import 'package:flutter_with_rethink_encrypted_app/models/local_message.dart';
import 'package:flutter_with_rethink_encrypted_app/viewmodels/chat_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataSource extends Mock implements IDatasource {}

void main() {
  ChatViewModel sut;
  MockDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockDataSource();
    sut = ChatViewModel(mockDataSource);
  });
  final message = Message.fromJson({
    'from': '111',
    'to': '222',
    'contents': 'hey',
    'timestamp': DateTime.parse("2022-01-17"),
    'id': '4444'
  });
  test('initial messages return empty list', () async {
    //? I am asking Mockito below that wheneber findAllChats method is called return an empty array []
    when(mockDataSource.findMessages(any)).thenAnswer((_) async => []);
    expect(await sut.getMessages('123'), isEmpty);
  });
  test('returns list of messages from local storage', () async {
    final chat = Chat('123');
    final localmessage =
        LocalMessage(chat.id, message, ReceiptStatus.delivered);
    when(mockDataSource.findMessages(chat.id))
        .thenAnswer((_) async => [localmessage]);
    final messages = await sut.getMessages(chat.id);
    expect(messages, isNotEmpty);
    expect(messages.first.chatId, '123');
  });
  test('creates a new chat when sending first message', () async {
    //? when findChat is called mockito will return null for that function
    when(mockDataSource.findChat(any)).thenAnswer((_) => null);
    //? sentMessage has everything teh tak jana
    await sut.sentMessage(message);
    verify(mockDataSource.addChat(any)).called(1);
  });
  test('add new sent message to this chat', () async {
    final chat = Chat('123');
    final localMessage =
        LocalMessage(chat.id, message, ReceiptStatus.delivered);
    when(mockDataSource.findMessages(chat.id))
        .thenAnswer((_) async => [localMessage]);
    await sut.getMessages(chat.id);
    await sut.sentMessage(message);
    verifyNever(mockDataSource.addChat(any));
    verify(mockDataSource.addMessage(any)).called(1);
  });
  test('create a new chat when message recieved is not a part of this chat',
      () async {
    final chat = Chat('123');
    final localMessage =
        LocalMessage(chat.id, message, ReceiptStatus.delivered);
    when(mockDataSource.findMessages(chat.id))
        .thenAnswer((_) async => [localMessage]);
    when(mockDataSource.findChat(chat.id)).thenAnswer((_) async => null);
    await sut.getMessages(chat.id);
    await sut.recievedMessage(message);
    verify(mockDataSource.addChat(any)).called(1);
    verify(mockDataSource.addMessage(any)).called(1);
    expect(sut.otherMessages, 1);
  });
}
