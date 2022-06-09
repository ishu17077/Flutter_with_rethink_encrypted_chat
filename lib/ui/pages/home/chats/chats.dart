import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_app/colors.dart';
import 'package:flutter_firebase_chat_app/theme.dart';
import 'package:flutter_firebase_chat_app/ui/pages/home/profile_image.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 30.0, right: 16.0),
      itemBuilder: (_, indx) => _chatItem(),
      separatorBuilder: (_, __) => Divider(),
      itemCount: 3,
    );
  }

  _chatItem() {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 16.0),
      leading: const ProfileImage(
        imageUrl:
            'https://images.pexels.com/photos/1052150/pexels-photo-1052150.jpeg',
        online: true,
      ),
      title: Text(
        'Ligma',
        style: Theme.of(context).textTheme.subtitle2?.copyWith(
              fontWeight: FontWeight.bold,
              color: isLightTheme(context) ? Colors.black : Colors.white,
            ),
      ),
      subtitle: Text(
        'balls!',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        style: Theme.of(context).textTheme.overline?.copyWith(
              color: isLightTheme(context) ? Colors.black54 : Colors.white70,
            ),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '12 a.m.',
            style: Theme.of(context).textTheme.overline?.copyWith(
                  color:
                      isLightTheme(context) ? Colors.black54 : Colors.white70,
                ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Container(
                height: 20.0,
                width: 20.0,
                color: kPrimary,
                alignment: Alignment.center,
                child: Text(
                  '69',
                  style: Theme.of(context).textTheme.overline?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
