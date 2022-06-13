// ignore_for_file: import_of_legacy_library_into_null_safe, duplicate_ignore

import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
// ignore: implementation_imports, import_of_legacy_library_into_null_safe
// import 'package:chat/src/services/user/user_service_contract.dart';
import 'package:flutter_with_rethink_encrypted_app/cache/local_cache.dart';
import 'package:flutter_with_rethink_encrypted_app/states_management/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final IUserService _userService;
  final ILocalCache _localCache;
  HomeCubit(this._userService, this._localCache) : super(HomeInitial());

  Future<User> connect() async {
    final userJson =
        _localCache.fetch('USER'); //? Updating myself to the database
    userJson['last_seen'] = DateTime.now();
    userJson['active'] = true;

    final user = User.fromJson(userJson);
    await _userService.connect(user);
    return user;
  }

  Future<void> activeUsers(User user) async {
    emit(HomeLoading());
    final users = await _userService.online();
    users.removeWhere((element) => element.id == user.id);
    //? Remopve user where any of online users id matches with user passed
    emit(HomeSuccess(users));
  }
}
