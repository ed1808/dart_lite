import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

String makePassword(String plainPassword, String secretKey) {
  final Uint8List key = utf8.encode(secretKey);
  final Uint8List passwordBytes = utf8.encode(plainPassword);
  final Digest hashedPassword = sha256.convert(passwordBytes);

  final Hmac hasher = Hmac(sha256, key);
  final Digest digest = hasher.convert(hashedPassword.bytes);

  return digest.toString();
}

bool validatePassword(
    String plainPassword, String storedPassword, String secretKey) {
  final String hashedPassword = makePassword(plainPassword, secretKey);

  final Uint8List hashedPasswordBytes = utf8.encode(hashedPassword);
  final Uint8List storedPasswordBytes = utf8.encode(storedPassword);

  if (hashedPasswordBytes.length != storedPasswordBytes.length) {
    return false;
  }

  for (var i = 0; i < hashedPasswordBytes.length; i++) {
    if (hashedPasswordBytes[i] != storedPasswordBytes[i]) {
      return false;
    }
  }

  return true;
}
