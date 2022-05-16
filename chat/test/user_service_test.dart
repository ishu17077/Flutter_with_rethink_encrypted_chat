// @dart=2.9
import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/user/user_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

import 'helpers.dart';

void main() async {
  Rethinkdb r = Rethinkdb();
  Connection connection;
  UserService sut;
  // connection = await r.connect();
  // sut = UserService(r: r, connection: connection);
  setUp(() async {
    connection = await r.connect(host: "127.0.0.1", port: 28015);
    await createDb(r, connection);
    sut = UserService(r, connection);
  });
  tearDown(() async {
    await cleanDb(r, connection);
  });
  test('create a new user document in database', () async {
    await createDb(r, connection);
    final user = User(
      username: 'test',
      photoUrl: 'url',
      active: true,
      lastseen: DateTime.now(),
    );
    final userWithId = await sut.connect(user);
    expect(userWithId.id, isNotEmpty);
  });
  test('get users online', () async {
    final user = User(
      username: 'test',
      photoUrl: 'url',
      active: true,
      lastseen: DateTime.now(),
    );
    await sut.connect(user);
    final users = await sut.online();
    expect(users.length, 1);
  });
}
