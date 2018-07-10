import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:social_vertex_flutter/requests.dart';

// use stdout
void main() {
  test("test Socket", () async {
    var socket = await Socket.connect('polyglot.net.cn', 8081);
    socketOperator(socket,(data){
      String str = ints2String(data);
      stdout.write(str);
    });
    stdout.write(" "); // this is prerequisite, otherwise it won't output anything.
    socket.close();
  });
}
