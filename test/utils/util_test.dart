import 'package:flutter_test/flutter_test.dart';
import 'package:social_vertex_flutter/utils/util.dart';

void main() {
  test('test md5 encoding function', () {
    var result = md5("123456");
    expect(result, "e10adc3949ba59abbe56e057f20f883e");
  });
}