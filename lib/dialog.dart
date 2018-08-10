import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'config/constants.dart' as constants;
import 'main.dart';

var _message = "";

Widget showChatDialog(MyHomePageState state,[String message]) {

  if(!state.messages.containsKey(state.friendId)){
    state.messages[state.friendId] = [];
  }

  var messages = state.messages[state.friendId];

  var content = ListView.builder(
    padding: EdgeInsets.all(10.0),
    itemBuilder: (BuildContext context, int index) {
      Map item = messages[messages.length - 1 - index];

      var textAlign = TextAlign.start;
      if(item[constants.from] == state.id){
        textAlign = TextAlign.end;
      }

      var row = Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("${item[constants.from]}:\n${item[constants.body]}", textAlign: textAlign,),
            ),
          ),
        ],
      );

      if(item[constants.from] == state.id){
        row.children.add(Icon(Icons.message));
      }else{
        row.children.insert(0, Icon(Icons.message));
      }

      return row;
    },
    itemCount: messages.length,
  );

  return Scaffold(
    appBar: AppBar(
      title: Text(state.friendNickname == null ? state.friendId : state.friendNickname.trim()),
      centerTitle: true,
      leading: IconButton(
          icon: InputDecorator(
            decoration: InputDecoration(icon: Icon(Icons.arrow_back)),
          ),
          onPressed: () {
            state.updateUI(constants.userPage);
          }),
    ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: content,
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
                    text: _message,
                  ),
                ),
              ),
              RaisedButton(
                child: Text("发送"),
                onPressed: () {
                  var message = {
                    constants.type: constants.message,
                    constants.subtype: constants.text,
                    constants.from: state.id,
                    constants.to: state.friendId,
                    constants.body: _message,
                    constants.version: constants.currentVersion
                  };
                  state.messages[state.friendId].add(message);
                  state.updateCurrentUI();
                  state.sendMessage(json.encode(message));
                  _message = "";
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
