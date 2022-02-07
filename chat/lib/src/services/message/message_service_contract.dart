// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:chat/src/models/message.dart';
import 'package:chat/src/models/user.dart';

abstract class IMessageService {
  Future<bool> send(Message message);
  Stream<Message> messages({required User activeUser});
  dispose();
}
