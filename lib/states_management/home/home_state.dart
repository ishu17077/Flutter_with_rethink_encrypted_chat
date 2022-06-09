// ignore: import_of_legacy_library_into_null_safe, implementation_imports
import 'package:chat/src/models/user.dart';
import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeSuccess extends HomeState {
  final List<User> onlineUsers;
  HomeSuccess(this.onlineUsers);
  @override
  List<Object?> get props => [onlineUsers];
}
