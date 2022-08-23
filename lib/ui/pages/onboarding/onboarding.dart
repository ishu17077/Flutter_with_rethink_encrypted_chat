//@dart = 2.9
import 'package:flutter/material.dart';
import 'package:flutter_with_rethink_encrypted_app/colors.dart';
import 'package:flutter_with_rethink_encrypted_app/states_management/onboarding/onboarding_cubit.dart';
import 'package:flutter_with_rethink_encrypted_app/states_management/onboarding/onoarding_state.dart';
import 'package:flutter_with_rethink_encrypted_app/states_management/onboarding/profile_image_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_with_rethink_encrypted_app/ui/pages/onboarding/onboarding_router.dart';
import '../../widgets/onboarding/logo.dart';
import '../../widgets/onboarding/profile_upload.dart';
import '../../widgets/shared/custom_text_field.dart';

class Onboarding extends StatefulWidget {
  final IOnboardingRouter router;
  // ignore: use_key_in_widget_constructors, prefer_const_constructors_in_immutables
  Onboarding(this.router);
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  String _username = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _logo(context),
            const Spacer(flex: 1),
            const ProfileUpload(),
            const Spacer(flex: 1),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: CustomTextField(
                hint: "What's your name?",
                onChanged: (val) {
                  _username = val;
                },
                inputAction: TextInputAction.done,
                height: 45.0,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  final error = _checkInputs();
                  if (error.isNotEmpty) {
                    final snackBar = SnackBar(
                        content: Text(
                      error,
                      style: const TextStyle(fontSize: 16.0),
                    ));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    return;
                  }
                  await _connectSession();
                },
                child: Container(
                  height: 45.0,
                  alignment: Alignment.center,
                  child: Text(
                    'Welcome!',
                    style: Theme.of(context).textTheme.button.copyWith(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: kPrimary,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45.0))),
              ),
            ),
            const Spacer(flex: 2),
            BlocConsumer<OnboardingCubit, OnboardingState>(
              builder: (context, state) => state is Loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(),
              listener: (_, state) {
                if (state is OnboardingSuccess) {
                  widget.router.onSessionSuccess(context, state.user);
                  //? The widget parameter is used to predefine and get the variable from upper create state class

                }
              },
            ),
            const Spacer(flex: 1)
          ],
        ),
      ),
    );
  }

  _logo(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Chat',
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8.0),
        const Logo(),
        const SizedBox(width: 8.0),
        Text(
          'Chat',
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  _connectSession() async {
    final profileImage = context.read<ProfileImageCubit>().state;
    await context.read<OnboardingCubit>().connect(_username, profileImage);
  }

  String _checkInputs() {
    var error = '';
    if (_username.isEmpty) error = 'Enter display name';
    if (context.read<ProfileImageCubit>().state == null) {
      error = error + '\n' + 'Upload Profile Image';
    }
    return error;
  }
}
