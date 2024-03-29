//@dart = 2.9
import 'package:chat/src/models/message.dart';
import 'package:flutter_with_rethink_encrypted_app/data/datasources/sqflite_datasource.dart';
import 'package:flutter_with_rethink_encrypted_app/models/chat.dart';
import 'package:flutter_with_rethink_encrypted_app/models/local_message.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:chat/src/models/receipt.dart';
import 'package:sqflite/sqlite_api.dart';

class MockSqfliteDatabase extends Mock implements Database {}

class MockBatch extends Mock implements Batch {}

void main() {
  SqfliteDatasource sut;
  MockSqfliteDatabase database;
  MockBatch batch;
  setUp(() {
    database = MockSqfliteDatabase();
    batch = MockBatch();
    sut = SqfliteDatasource(database);
  });
  final message = Message.fromJson({
    'from': '111',
    'to': '222',
    'timestamp': DateTime.parse('2021-11-01'),
    'contents': 'hey',
    'id': '4444',
  });
  test('should perform insert of chat to the database', () async {
    //? Arrange
    final localMessage = LocalMessage('1234', message, ReceiptStatus.sent);
    final chat =
        Chat('1234', messages: [localMessage], mostRecent: localMessage);
    // when(database.insert(
    //   'chats',
    //   chat.toMap(),
    //   conflictAlgorithm: ConflictAlgorithm.replace,
    // )).thenAnswer((_) async => 1);

    when(database.transaction((txn) async {
      await txn.insert('chats', chat.toMap(),
          conflictAlgorithm: ConflictAlgorithm.rollback);
    })).thenAnswer((_) async => null);
    //? Act
    await sut.addChat(chat);

    //? Assert
    ////verify(database.insert('chats', chat.toMap(),
    ////         conflictAlgorithm: ConflictAlgorithm.replace))
    ////     .called(1);
    expect(database.transaction((txn) async {
      await txn.insert('chats', chat.toMap(),
          conflictAlgorithm: ConflictAlgorithm.rollback);
    }), null);
    //// verifyNever(database.transaction(any));
  });

  test('should perform insert of message to the database', () async {
    //? Arrange
    final localMessage = LocalMessage('1234', message, ReceiptStatus.sent);
    when(await database.transaction((txn) async {
      await txn.insert('messages', message.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }))
        .thenReturn(null);
    //? Act
    await sut.addMessage(localMessage);

    //? Assert
    verify(database.transaction(any)).called(1);
  });
  test('should perform a databsase query and return message', () async {
    //? arrange
    final messagesMap = [
      {
        'chat_id': '111',
        'id': '4444',
        'from': '111',
        'to': '222',
        'contents': 'hey',
        'receipt': 'sent',
        'received_at': DateTime.parse("2022-01-16").toString(),
      }
    ];
    when(database.query(
      'messages',
      where: anyNamed('where'),
      whereArgs: anyNamed('whereArgs'),
    )).thenAnswer((_) async => messagesMap);

    //? act
    var messages = await sut.findMessages('111');

    //? assert
    expect(messages.length, 1);
    expect(messages.first.chatId, '111');
    verify(database.query(
      'messages',
      where: anyNamed('where'),
      whereArgs: anyNamed('whereArgs'),
    )).called(1);
  });

  test('should perform database update on messages', () async {
    //? Arrange
    final localMessage = LocalMessage('1234', message, ReceiptStatus.sent);
    when(database.update(
      'messages',
      localMessage.toMap(),
      where: anyNamed('where'),
      whereArgs: anyNamed('whereArgs'),
    )).thenAnswer((_) async => 1);
    await sut.updateMessage(localMessage);
    verify(database.update('messages', localMessage.toMap(),
            where: anyNamed('where'),
            whereArgs: anyNamed('whereArgs'),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .called(1);
  });

  test('should perform database batch delete of chat', () async {
    //arrange
    final chatId = '111';
    when(database.batch()).thenReturn(batch);

    //act
    await sut.deleteChat(chatId);

    //assert
    verifyInOrder([
      database.batch(),
      batch.delete('messages', where: anyNamed('where'), whereArgs: [chatId]),
      batch.delete('chats', where: anyNamed('where'), whereArgs: [chatId]),
      batch.commit(noResult: true)
    ]);
  });
}
