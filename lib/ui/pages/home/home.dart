import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_app/states_management/home/home_cubit.dart';
import 'package:flutter_firebase_chat_app/states_management/home/home_state.dart';
import 'package:flutter_firebase_chat_app/ui/pages/home/active/active_users.dart';
import 'package:flutter_firebase_chat_app/ui/pages/home/chats/chats.dart';
import 'package:flutter_firebase_chat_app/ui/pages/home/profile_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home();
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().activeUsers();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Container(
              width: double.maxFinite,
              child: Row(
                children: [
                  const ProfileImage(
                    imageUrl:
                        "https://images.pexels.com/photos/1052150/pexels-photo-1052150.jpeg",
                    online: true,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Mr. X",
                          style: Theme.of(context).textTheme.caption?.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(
                          "online",
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            bottom: TabBar(
              indicatorPadding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              tabs: [
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
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
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: BlocBuilder<HomeCubit, HomeState>(
                          builder: (_, state) => state is HomeSuccess
                              ? Text('Active(${state.onlineUsers.length})')
                              : const Text('Active(0)')),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              Chats(),
              ActiveUsers(),
            ],
          ),
        ));
  }
}
