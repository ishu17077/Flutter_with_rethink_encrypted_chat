// ignore_for_file: import_of_legacy_library_into_null_safe, implementation_imports

import 'package:chat/src/models/user.dart';
import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {}

class OnboardingInitial extends OnboardingState {
  @override
  List<Object> get props => [];
}

class Loading extends OnboardingState {
  @override
  List<Object> get props => [];
}

class OnboardingSuccess extends OnboardingState {
  final User user;
  OnboardingSuccess(this.user);
  @override
  List<Object> get props => [user];
}
