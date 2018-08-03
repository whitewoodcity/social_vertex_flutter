import 'package:flutter_test/flutter_test.dart';
import 'package:social_vertex_flutter/utils/requests.dart';

void main() {
  test('test md5 encoding function', () {
    var md5 = generateMd5("123456");
    expect(md5, "e10adc3949ba59abbe56e057f20f883e");
  });
}