//@dart=2.9
import 'package:chat/chat.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

import 'helpers.dart';

void main() {
  Rethinkdb r = Rethinkdb();
  Connection connection;
  TypingNotification sut;
  UserService _userService;

  setUp(() async {
    connection = await r.connect();
    await createDb(r, connection);
    sut = TypingNotification(r, connection, _userService);
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

  final user2 = User.fromJson({
    'id': '1111',
    'active': true,
    'lastSeen': DateTime.now(),
  });
  test('sent typing notification successfully', () async {
    TypingEvent typingEvent =
        TypingEvent(from: user2.id, to: user.id, event: Typing.start);
    final res = await sut.send(event: typingEvent);
    expect(res, true);
  });
  test('successfully subscribe and receive receipts', () async {
    sut.subscribe(user2, [user.id]).listen(expectAsync1((event) {
      expect(event.from, user.id);
    }, count: 2));

    TypingEvent typing = TypingEvent(
      from: user.id,
      to: user2.id,
      event: Typing.start,
    );

    TypingEvent stopTyping = TypingEvent(
      from: user.id,
      to: user2.id,
      event: Typing.stop,
    );
    await sut.send(event: typing);
    await sut.send(event: stopTyping);
  });
}
