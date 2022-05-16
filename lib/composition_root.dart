//@dart = 2.9
import 'package:chat/chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_chat_app/data/services/image_uploader.dart';
import 'package:flutter_firebase_chat_app/states_management/onboarding/onboarding_cubit.dart';
import 'package:flutter_firebase_chat_app/states_management/onboarding/profile_image_cubit.dart';
import 'package:flutter_firebase_chat_app/ui/pages/onboarding/onboarding.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

class CompositionRoot {
  static Rethinkdb r;
  static Connection _connection;
  static IUserService _userService;

  static configure() async {
    r = Rethinkdb();
    _connection = await r.connect(host: '10.0.2.2', port: 28015);
    _userService = UserService(r, _connection);
  }

  static Widget composeOnBoardingUI() {
    ImageUploader imageUploader = ImageUploader('http://10.0.2.2:3000/upload');

    OnboardingCubit onboardingCubit =
        OnboardingCubit(_userService, imageUploader);
    ProfileImageCubit imageCubit = ProfileImageCubit();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => onboardingCubit),
        BlocProvider(create: (BuildContext context) => imageCubit),
      ],
      child: Onboarding(),
    );
  }
}