//@dart =2.9
import 'package:flutter/material.dart';
import 'package:flutter_with_rethink_encrypted_app/ui/widgets/home/profile_image.dart';
import 'package:intl/intl.dart';

class HeaderStatus extends StatelessWidget {
  final String username;
  final String imageUrl;
  final bool online;
  final DateTime lastSeen;
  final bool typing;
  const HeaderStatus(this.username, this.imageUrl, this.online,
      {this.lastSeen, this.typing = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        children: [
          ProfileImage(
            imageUrl: imageUrl,
            online: online,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  username.trim(),
                  style: Theme.of(context).textTheme.caption?.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: typing == null || typing == false
                      ? Text(
                          online
                              ? 'online'
                              : 'last seen ${DateFormat.yMd().add_jm().format(lastSeen)}',
                          style: Theme.of(context).textTheme.caption)
                      : Text(
                          'typing..',
                          style: Theme.of(context).textTheme.caption.copyWith(
                              fontStyle: FontStyle.italic, color: Colors.green),
                        )),
            ],
          )
        ],
      ),
    );
  }
}
