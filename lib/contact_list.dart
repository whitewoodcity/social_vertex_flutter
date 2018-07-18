import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_vertex_flutter/datamodel/contacts_model.dart';
import 'user.dart';
import 'component/contact_list_item.dart';
import 'package:social_vertex_flutter/datamodel/user_info.dart' as userInfo;
import 'package:social_vertex_flutter/config/config.dart' as config;

List<Entry> _list = new List();
UserState _state;

Widget showContactsList(UserState state) {
  _state = state;
  print(_list.length);
  if (_list.length == 0) {
    _loadContacts();
  }
  return new ListView.builder(
    itemBuilder: (BuildContext context, int index) =>
        new ContactItem(_list[index]),
    itemCount: _list.length,
  );
}

void _loadContacts() async {
  var getFriendList = ''' {
    "type":"friend",
    "action":"list",
    "from":"${userInfo.id}",
    "version":0.1
  }''';
  Socket _socket;
  try {
    if (_socket != null) _socket.destroy();
    _socket = await Socket.connect(config.host, config.tcpPort);
    _socket.write(getFriendList);
    _socket.forEach((package) {
      var list = json.decode(utf8.decode(package));
      var groups = list["results"];
      for (var group in groups) {
        List<Entry> friends = new List();

        var lists = group["lists"];
        for (var friend in lists) {
          friends.add(new Entry(friend["nickname"]));
        }
        _list.add(new Entry(group["group"], friends));
      }
    });
    if (_socket != null) _socket.close();
    if (_socket != null) _socket.done;
  } catch (e) {
    _showMessage("网络似乎断开了....");
  }
}

void _showMessage(String message) {
  showDialog(
      context: _state.context,
      builder: (BuildContext context) => new SimpleDialog(
            title: new Text("消息"),
            children: <Widget>[
              new Center(
                child: new Text(message),
              ),
            ],
          ));
}
