//@dart = 2.9
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_with_rethink_encrypted_app/colors.dart';
import 'package:flutter_with_rethink_encrypted_app/states_management/onboarding/profile_image_cubit.dart';
import 'package:flutter_with_rethink_encrypted_app/theme.dart';

class ProfileUpload extends StatelessWidget {
  const ProfileUpload({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 126.0,
      width: 126.0,
      child: Material(
        color: isLightTheme(context)
            ? const Color(0xFFF2F2F2)
            : const Color(0xFF211E1E),
        borderRadius: BorderRadius.circular(126.0),
        child: InkWell(
          onTap: () async {
            await context.read<ProfileImageCubit>().getImage();
          },
          borderRadius: BorderRadius.circular(126.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: BlocBuilder<ProfileImageCubit, File>(
                  //?BlocBuilder is catching from ProfileImageCubit and type is file check Profile image cubit for more info
                  //* builder function is doing the thing  where state is the emitted file
                  //! Note the InkWell above whose onTap does call getImage
                  builder: (context, state) {
                    return state == null
                        ? Icon(Icons.person_outline_rounded,
                            size: 126.0,
                            color: isLightTheme(context)
                                ? kIconLight
                                : Colors.black)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(126.0),
                            child: Image.file(state,
                                width: 126, height: 126, fit: BoxFit.fill),
                          );
                  },
                ),
              ),
              const Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.add_circle_rounded,
                  color: kPrimary,
                  size: 38.0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
