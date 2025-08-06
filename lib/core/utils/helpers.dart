import 'dart:math';

String get generateUserId {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));

  // Set version (4) in byte[6]
  bytes[6] = (bytes[6] & 0x0F) | 0x40;
  // Set variant (RFC 4122) in byte[8]
  bytes[8] = (bytes[8] & 0x3F) | 0x80;

  String toHex(int byte) => byte.toRadixString(16).padLeft(2, '0');

  return '${toHex(bytes[0])}${toHex(bytes[1])}${toHex(bytes[2])}${toHex(bytes[3])}-'
      '${toHex(bytes[4])}${toHex(bytes[5])}-'
      '${toHex(bytes[6])}${toHex(bytes[7])}-'
      '${toHex(bytes[8])}${toHex(bytes[9])}-'
      '${toHex(bytes[10])}${toHex(bytes[11])}${toHex(bytes[12])}${toHex(bytes[13])}${toHex(bytes[14])}${toHex(bytes[15])}';
}
