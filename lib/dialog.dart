import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_vertex_flutter/component/message_item.dart';
import 'package:social_vertex_flutter/config/config.dart' as config;
import 'main.dart';

Widget showChatDialog(String name,MyHomePageState state,List<MessageEntry> list) {
  var _message = "";
  return new Scaffold(
    appBar: new AppBar(
      title: new Text(name == null ? "未知好友" : name),
      centerTitle: true,
      leading: new IconButton(
          icon: new InputDecorator(
            decoration: new InputDecoration(icon: new Icon(Icons.arrow_back)),
          ),
          onPressed: () {
            state.updateUi(2);

          }),
    ),
    body: new ListView(
      children: list,
    ),
    bottomNavigationBar: new BottomAppBar(
      child: new Row(
        children: <Widget>[
          new Expanded(child: new TextField(
            onChanged: (value) {
              _message = value;
            },
          )),
          new RaisedButton(
            child: new Text("发送"),
            onPressed: () {
              var message = '''{
            "type":"message",
            "from":"${state.userName}",
            "to":"$name",
             "body":"$_message",
              "version":0.1
                }''';
              state.sendMessage(message);
            },
          )
        ],
      ),
    ),
  );
}

