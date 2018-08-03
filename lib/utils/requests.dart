import 'dart:io';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;

String generateMd5(String data) {
  var content = Utf8Encoder().convert(data);
  var md5 = crypto.md5;
  var digest = md5.convert(content);
  var password = hex.encode(digest.bytes);
  return password;
}

void socketOperator(Socket socket, Function f) {
  socket.write(
      '{"type":"search","timestamp":"${DateTime.now().millisecondsSinceEpoch}"}');
  socket.listen(f);
}

String ints2String(List<int> data) {
  return String.fromCharCodes(data);
}
