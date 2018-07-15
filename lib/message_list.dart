import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_vertex_flutter/component/message.dart';
import 'user.dart';

var _context;
UserState _state;
List<Widget> _list = [];

Widget showMessageList(UserState state) {
  _state = state;
  _context = state.context;
  if (_list.isEmpty) _testData();

  return new ListView(
    children: _list,
  );
}

_testData() {
  _list.add(new Message("小李"));
  _list.add(new Message("小张"));
}
