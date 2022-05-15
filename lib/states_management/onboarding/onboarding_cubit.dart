import 'dart:io';

import 'package:chat/chat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_chat_app/data/services/image_uploader.dart';
import 'onoarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final IUserService _userService;
  final ImageUploader _imageUploader;

  OnboardingCubit(this._userService, this._imageUploader)
      : super(OnboardingInitial());

  Future<void> connect(String name, File profileImage) async {
    emit(Loading());
    final url = await _imageUploader.uploadImage(profileImage);
    final user = User(
      username: name,
      photoUrl: url,
      active: true,
      lastseen: DateTime.now(),
    );
    //? This is when a user connect to database and gets oneself's user's online status, name, photo & last seen
    final createdUser = await _userService.connect(user);
    emit(OnboardingSuccess(createdUser));
  }
}
