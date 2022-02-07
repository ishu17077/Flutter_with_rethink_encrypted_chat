// ignore: import_of_legacy_library_into_null_safe
import 'package:chat/src/models/receipt.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:chat/src/models/user.dart';

abstract class IReceiptService {
  Future<bool> send(Receipt receipt);
  Stream<Receipt> receipts({User user});
  void dispose();
}
