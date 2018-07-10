import 'dart:io';

void socketOperator(Socket socket, Function f) {
  socket.write(
      '{"type":"search","timestamp":"${new DateTime.now().millisecondsSinceEpoch}"}');
  socket.listen(f);
}

String ints2String(List<int> data) {
  return new String.fromCharCodes(data);
}
