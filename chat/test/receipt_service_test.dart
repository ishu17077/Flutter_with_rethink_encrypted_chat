//@dart = 2.9
import 'helpers.dart';
import 'package:chat/src/models/receipt.dart';
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/receipt/receipt_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

void main() {
  Rethinkdb r = Rethinkdb();
  Connection connection;
  ReceiptService sut;

  setUp(() async {
    connection = await r.connect();
    await createDb(r, connection);
    sut = ReceiptService(r, connection);
  });

  tearDown(() async {
    sut.dispose();
    await cleanDb(r, connection);
  });

  final user = User.fromJson({
    'id': '1234',
    'active': true,
    'lastSeen': DateTime.now(),
  });

  test('sent receipt successfully', () async {
    Receipt receipt = Receipt(
        recipient: '444',
        messageId: '1234',
        status: ReceiptStatus.delivered,
        timestamp: DateTime.now());

    final res = await sut.send(receipt);
    expect(res, true);
  });
  test('successfully subscribe and receive receipts', () async {
    sut.receipts(user: user).listen(expectAsync1((receipt) {
          expect(receipt.recipient, user.id);
        }, count: 2));

    Receipt receipt = Receipt(
        recipient: user.id,
        messageId: '1234',
        status: ReceiptStatus.delivered,
        timestamp: DateTime.now());

    Receipt anotherReceipt = Receipt(
        recipient: user.id,
        messageId: '1234',
        status: ReceiptStatus.read,
        timestamp: DateTime.now());

    await sut.send(receipt);
    await sut.send(anotherReceipt);
  });
}
