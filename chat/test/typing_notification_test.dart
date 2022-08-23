//@dart=2.9
import 'package:chat/chat.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

import 'helpers.dart';

void main() {
  Rethinkdb _r = Rethinkdb();
  Connection _connection;
  TypingNotification sut;
  UserService _userService;
  User userWithId;
  User userWithId2;

  setUp(() async {
    _connection = await _r.connect(host: '192.168.2.49', port: 28015);
    await createDb(_r, _connection);
    _userService = UserService(_r, _connection);
    sut = TypingNotification(_r, _connection, _userService);

    final user = User(
      username: 'test',
      photoUrl: 'url',
      active: true,
      lastseen: DateTime.now(),
    );
    final user2 = User(
      username: 'test2',
      photoUrl: 'photoUrl',
      active: true,
      lastseen: DateTime.now(),
    );
    userWithId = await _userService.connect(user);
    userWithId2 = await _userService.connect(user2);
  });
  tearDown(() async {
    sut.dispose();
    await cleanDb(_r, _connection);
  });

  test('sent typing notification successfully', () async {
    TypingEvent typingEvent = TypingEvent(
        from: userWithId.id, to: userWithId2.id, event: Typing.start);
    final res = await sut.send(event: typingEvent);
    expect(res, true);
  });
  test('successfully subscribe and receive typing events', () async {
    sut.subscribe(userWithId2, [userWithId.id]).listen(expectAsync1((event) {
      expect(event.from, userWithId.id);
    }, count: 2));

    TypingEvent typing = TypingEvent(
      from: userWithId.id,
      to: userWithId2.id,
      event: Typing.start,
    );

    TypingEvent stopTyping = TypingEvent(
      from: userWithId.id,
      to: userWithId2.id,
      event: Typing.stop,
    );
    await sut.send(event: typing);
    await sut.send(event: stopTyping);
  });
}
