import 'dart:convert';

import 'package:social_vertex_flutter/utils/util.dart';
import 'package:test_api/test_api.dart';
import 'package:uuid/uuid.dart';

void main() {
  test('test md5 encoding function', () {
    var result = md5("123456");
    expect(result, "e10adc3949ba59abbe56e057f20f883e");
  });

  test('test uuid', () {

    var uuid = new Uuid();

    print(uuid.v4().toString().replaceAll("-", ""));

    List<String> colors = ['red', 'green', 'blue', 'orange', 'pink', ...["test"]];
    print(colors);
  });

  test('test utf-8',(){
    var map = {"测试":"test"};
    print(json.encode(map));
  });
}