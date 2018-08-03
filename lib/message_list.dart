import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_vertex_flutter/component/message_list_item.dart';
import 'main.dart';

List<String> _list = [];
MyHomePageState _homeState;

Widget showMessageList(MyHomePageState state) {
  _homeState = state;
  return ListView.builder(
    itemBuilder: (BuildContext context, int index) =>
        MessageListItem(_list[index]),
    itemCount: _list.length,
  );
}
