import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'component/message_item.dart';
import 'main.dart';

Widget showChatDialog(
    String name, MyHomePageState state,[String message]) {
  var _message = "";
  if(state.curChartTarget!=name) state.messageList.removeRange(0, state.messageList.length);
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
            children: state.messageList,
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
