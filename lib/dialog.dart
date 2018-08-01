import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_vertex_flutter/component/message_item.dart';
import 'main.dart';

Widget showChatDialog(
    String name, MyHomePageState state, List<MessageEntry> list) {
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
    body: new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new Expanded(
          child: new ListView(
            children: list,
          ),
        ),
        new Container(
          color: Colors.white,
          padding: new EdgeInsets.all(10.0),
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  onChanged: (value) {
                    _message = value;
                  },
                  controller: new TextEditingController(
                    text: "",
                  ),
                ),
              ),
              new RaisedButton(
                child: new Text("发送"),
                onPressed: () {
                  var message = '''{
            "type":"message",
            "subtype":"text"
            "to":"$name",
             "body":"$_message",
             "version":0.1
                }''';
                  state.sendMessage(message);
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
