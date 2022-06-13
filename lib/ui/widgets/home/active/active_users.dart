// ignore_for_file: implementation_imports, import_of_legacy_library_into_null_safe, use_key_in_widget_constructors

import 'package:chat/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_with_rethink_encrypted_app/states_management/home/home_cubit.dart';
import 'package:flutter_with_rethink_encrypted_app/states_management/home/home_state.dart';
import 'package:flutter_with_rethink_encrypted_app/states_management/onboarding/onoarding_state.dart';
import 'package:flutter_with_rethink_encrypted_app/ui/pages/home/home_router.dart';
import 'package:flutter_with_rethink_encrypted_app/ui/widgets/home/profile_image.dart';

class ActiveUsers extends StatefulWidget {
  final User me;
  final IHomeRouter router;

  // ignore: prefer_const_constructors_in_immutables
  ActiveUsers(this.me, this.router);

  @override
  State<ActiveUsers> createState() => _ActiveUsersState();
}

class _ActiveUsersState extends State<ActiveUsers> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (_, state) {
      if (state is Loading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state is HomeSuccess) return _buildList(state.onlineUsers);
      return Container();
    });
  }

  _listItem(User user) {
    return ListTile(
      leading: ProfileImage(
        imageUrl: user.photoUrl,
        online: true,
      ),
      title: Text(
        user.username,
        style: Theme.of(context).textTheme.caption?.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  _buildList(List<User> users) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 30.0, right: 16.0),
      itemBuilder: (_, indx) => GestureDetector(
        child: _listItem(users[indx]),
        onTap: () => widget.router.onShowMessageThread(
            context, users[indx], widget.me,
            chatId: users[indx].id),
      ),
      separatorBuilder: (_, __) => const Divider(),
      itemCount: users.length,
    );
  }
}
