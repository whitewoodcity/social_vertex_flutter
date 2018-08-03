import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_vertex_flutter/component/message_item.dart';
import 'main.dart';

Widget showChatDialog(
    String name, MyHomePageState state, List<MessageEntry> list) {
  var _message = "";
  if(state.curChartTarget!=name) list.removeRange(0, list.length);
  state.curChartTarget = name;
  return Scaffold(
    appBar: AppBar(
      title: Text(name == null ? "未知好友" : name.trim()),
      centerTitle: true,
      leading: IconButton(
          icon: InputDecorator(
            decoration: InputDecoration(icon: Icon(Icons.arrow_back)),
          ),
          onPressed: () {
            state.updateUi(2);
          }),
    ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: ListView(
            children: list,
          ),
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    _message = value;
                  },
                  controller: TextEditingController(
                    text: "",
                  ),
                ),
              ),
              RaisedButton(
                child: Text("发送"),
                onPressed: () {
                  var message = {
                    "type": "message",
                    "subtype": "text",
                    "to": "$name",
                    "body": "$_message",
                    "version": 0.1
                  };
                  state.updateChartList(_message);
                  state.sendMessage(json.encode(message)+"\r\n");
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
