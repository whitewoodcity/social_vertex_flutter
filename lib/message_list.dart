import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_vertex_flutter/component/message.dart';
import 'package:social_vertex_flutter/component/message_list_item.dart';
import 'user.dart';
import 'package:social_vertex_flutter/config/config.dart' as config;

var _context;
UserState _state;
List<String> _list = [];

Widget showMessageList(UserState state) {
  _state = state;
  _context = state.context;
 if(_list.length==0) _loadData();
  return new ListView.builder(
    itemBuilder: (BuildContext context,int index)=>new MessageListItem(_list[index]),
    itemCount: _list.length,

  );
}
void _loadData(){   //测试数据
  _list.add("小张");
  _list.add("小明");
}
