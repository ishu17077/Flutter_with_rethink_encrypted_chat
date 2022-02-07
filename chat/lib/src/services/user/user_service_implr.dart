import 'package:chat/src/models/user.dart';
import 'package:chat/src/services/user/user_service_contract.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

class UserService implements IUserService {
  final Connection connection;
  final Rethinkdb r;

  UserService({required this.r, required this.connection});
  @override
  Future<User> connect(User user) async {
    var data = user.toJson();
    if (user.id != null) {
      data['id'] = user.id;
    }
    final result = await r.table('users').insert(data, {
      'conflict': 'update',
      'return_changes': true,
    }).run(connection);
    return User.fromJson(result['changes'].first['new_val']);
  }

  @override
  Future<void> disconnect(User user) async {
    //! throw UnimplementedError();
    await r.table('users').update({
      'id': user.id,
      'active': false,
      'last_seen': DateTime.now()
    }).run(connection);
    connection.close();
  }

  @override
  Future<List<User>> online() async {
    //! throw UnimplementedError();
    Cursor users =
        await r.table('users').filter({'active': true}).run(connection);
    final userList = await users.toList();
    return userList.map((item) => User.fromJson(item)).toList();
  }
}
