import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
// ignore: implementation_imports, import_of_legacy_library_into_null_safe
import 'package:chat/src/services/user/user_service_contract.dart';
import 'package:flutter_firebase_chat_app/states_management/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  IUserService _userService;
  HomeCubit(this._userService) : super(HomeInitial());

  Future<void> activeUsers() async {
    emit(HomeLoading());
    final users = await _userService.online();
    emit(HomeSuccess(users));
  }
}
