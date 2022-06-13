// ignore_for_file: import_of_legacy_library_into_null_safe, implementation_imports

import 'package:chat/src/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_with_rethink_encrypted_app/states_management/home/chats_cubit.dart';
import 'package:flutter_with_rethink_encrypted_app/states_management/home/home_cubit.dart';
import 'package:flutter_with_rethink_encrypted_app/states_management/home/home_state.dart';
import 'package:flutter_with_rethink_encrypted_app/states_management/message/message_bloc.dart';
import 'package:flutter_with_rethink_encrypted_app/ui/pages/home/home_router.dart';

import 'package:flutter_with_rethink_encrypted_app/ui/widgets/home/active/active_users.dart';
import 'package:flutter_with_rethink_encrypted_app/ui/widgets/home/chats/chats.dart';
import 'package:flutter_with_rethink_encrypted_app/ui/widgets/home/profile_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_with_rethink_encrypted_app/ui/widgets/shared/header_status.dart';

class Home extends StatefulWidget {
  final User me;
  final IHomeRouter router;
  // ignore: use_key_in_widget_constructors
  const Home(this.me, this.router);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  //? ALlows the class to live on its own so a new class is not created at every instance
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = widget.me;
    _initialSetup();
  }

  void _initialSetup() async {
    final user =
        (!_user.active) ? await context.read<HomeCubit>().connect() : _user;

    context.read<ChatsCubit>().chats();
    context.read<HomeCubit>().activeUsers(user);
    context.read<MessageBloc>().add(MessageEvent.onSubscribed(_user));
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          // ignore: sized_box_for_whitespace
          title: HeaderStatus(
            _user.username,
            _user.photoUrl,
            true,
            lastSeen: _user.lastseen,
          ),
          bottom: TabBar(
            indicatorPadding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            tabs: [
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text('Messages'),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: BlocBuilder<HomeCubit, HomeState>(
                        builder: (_, state) => state is HomeSuccess
                            ? Text('Active(${state.onlineUsers.length})')
                            : const Text('Active(0)')),
                  ),
                ),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Chats(_user, widget.router),
            ActiveUsers(_user, widget.router),
          ],
        ),
      ),
    );
  }
}
