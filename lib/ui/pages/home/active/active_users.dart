import 'package:chat/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_chat_app/states_management/home/home_cubit.dart';
import 'package:flutter_firebase_chat_app/states_management/home/home_state.dart';
import 'package:flutter_firebase_chat_app/states_management/onboarding/onoarding_state.dart';
import 'package:flutter_firebase_chat_app/ui/pages/home/profile_image.dart';

class ActiveUsers extends StatefulWidget {
  const ActiveUsers({Key? key}) : super(key: key);

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
    print(user.photoUrl);
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
      itemBuilder: (_, indx) => _listItem(users[indx]),
      separatorBuilder: (_, __) => Divider(),
      itemCount: users.length,
    );
  }
}
