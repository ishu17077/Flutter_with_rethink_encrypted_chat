import 'package:chat/src/services/encryption/encryption_contract.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:encrypt/encrypt.dart';

class EncryptionService implements IEncryption {
  final Encrypter _encypter;
  final _iv = IV.fromLength(16);

  EncryptionService(this._encypter);

  @override
  String encrypt(String text) {
    return _encypter.encrypt(text, iv: _iv).base64;
  }

  @override
  String decrypt(String encryptedText) {
    final encrypted = Encrypted.fromBase64(encryptedText);
    return _encypter.decrypt(encrypted, iv: _iv);
  }
}
