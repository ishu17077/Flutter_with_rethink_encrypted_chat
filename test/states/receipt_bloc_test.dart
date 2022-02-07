// @dart=2.9
import 'package:chat/src/models/user.dart';
import 'package:chat/src/models/receipt.dart';
import 'package:chat/src/services/receipt/receipt_service_contract.dart';
import 'package:flutter_firebase_chat_app/states_management/message/message_bloc.dart';
import 'package:flutter_firebase_chat_app/states_management/receipt/receipt_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FakeReceiptService extends Mock implements IReceiptService {}

void main() {
  ReceiptBloc sut;
  IReceiptService receiptService;
  User user;

  setUp(() {
    receiptService = FakeReceiptService();
    user = User(
      active: true,
      lastseen: DateTime.now(),
      photoUrl: '',
      username: 'test',
    );
    sut = ReceiptBloc(receiptService);
  });
  tearDown(() {
    sut.close();
  });

  test('should emit initial only without subscriptions', () {
    expect(sut.state, ReceiptInitial());
  });

  test('should emit message delievered state when message is sent', () {
    final receipt = Receipt(
      messageId: '123',
      recipient: '345',
      status: ReceiptStatus.sent,
      timestamp: DateTime.now(),
    );

    when(receiptService.send(receipt)).thenAnswer((_) async => null);
    sut.add(ReceiptEvent.onReceiptSent(receipt));
    expectLater(sut.stream, emits(ReceiptState.sent(receipt)));
  });
  test('should emit receipts recieved from service', () {
    final receipt = Receipt(
      messageId: '123',
      recipient: '345',
      status: ReceiptStatus.delievered,
      timestamp: DateTime.now(),
    );
    when(receiptService.receipts(user: anyNamed('user')))
        //? anyNamed essencially stands anyNamed parameter activeUser: any
        .thenAnswer((_) => Stream.fromIterable([receipt]));

    sut.add(ReceiptEvent.onSubscribed(user));
    //* expectLater(sut.stream, emits(ReceiptState.received(receipt))); //Try executing commented code, all run
    //* expectLater(sut.stream, emitsInOrder([ReceiptState.received(receipt)]));
    expectLater(sut.stream, emitsInOrder([ReceiptReceivedSuccess(receipt)]));
  });
}
