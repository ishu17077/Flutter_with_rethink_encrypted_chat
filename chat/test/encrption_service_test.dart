// @dart=2.9
import 'package:chat/src/services/encryption/encryption_contract.dart';
import 'package:chat/src/services/encryption/encyption_service.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  IEncryption sut;
  setUp(() {
    final encrypter = Encrypter(AES(Key.fromLength(32)));
    sut = EncryptionService(encrypter);
  });
  void printText(String text) {
    print('Message: ' + '\x1B[33m$text\x1B[0m');
  }

  void printEncryptedText(String encryptedText) {
    print('Encrypted Text AES-256: ' + '\x1B[32m$encryptedText\x1B[0m');
  }

  test('it encrpyts the plain text😁', () {
    const text = 'Encryption is ready to be implemented!🏄';
    printText('Namaste!');
    final base64 = RegExp(
        r'^(?:[A-Za-z0-9+\/]{4})*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{4})$');
    final encrypted = sut.encrypt(text);
    print('Encrypting.....🔥');
    printEncryptedText(encrypted);
    expect(base64.hasMatch(encrypted), true);
  });
  test('it decrypts the encrypted text😎', () {
    const text = 'Oh that\'s great, looking forward to it!🤫';
    final encrypted = sut.encrypt(text);
    printEncryptedText(encrypted);
    final decrypted = sut.decrypt(encrypted);
    print('Decrypting.....🤾');
    printText(decrypted);
    expect(decrypted, text);
  });
}
