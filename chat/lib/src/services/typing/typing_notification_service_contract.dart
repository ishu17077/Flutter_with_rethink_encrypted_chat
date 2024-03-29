// ignore: import_of_legacy_library_into_null_safe
import 'package:chat/src/models/typing_event.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:chat/src/models/user.dart';

import 'package:flutter/foundation.dart';

abstract class ITypingNotification {
  Future<bool> send({@required TypingEvent event});
  Stream<TypingEvent> subscribe(User user, List<String> userIds);
  void dispose();
}
