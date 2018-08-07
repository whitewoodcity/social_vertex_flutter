import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'system_info.dart';
import 'component/application_menu.dart';
import 'main.dart';
import 'package:social_vertex_flutter/config/config.dart' as config;

MyHomePageState homeState;

Widget showUser(MyHomePageState state) {
  homeState = state;
  _obtainLeftMessage();

  int _curPage = 0;
  return Scaffold(
    appBar: AppBar(
      title: Text("消息"),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: InputDecorator(
            decoration: InputDecoration(icon: Icon(Icons.add)),
          ),
          onPressed: () {
            homeState.updateUi(4);
          },
        ),
      ],
    ),
    drawer: Drawer(
      child: showAppMenu(homeState.userName),
    ),
    body: ListView.builder(
      itemBuilder: (BuildContext context, int index) => MessageListItem(
          homeState.userMessage[index]._name,
          homeState.userMessage[index]._type,
          homeState,
          homeState.userMessage[index]._message),
      itemCount: homeState.userMessage.length,
    ),
    bottomNavigationBar: BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/message.png",
              width: 30.0,
              height: 30.0,
            ),
            title: Text("消息")),
        BottomNavigationBarItem(
            icon: Image.asset(
              "assets/images/contacts.png",
              width: 30.0,
              height: 30.0,
            ),
            title: Text("联系人")),
      ],
      onTap: (index) {
        if (index == 1) {
          state.updateUi(2);
        }
      },
      currentIndex: _curPage,
    ),
  );
}

void _obtainLeftMessage() {
  var req = {
    "type": "user",
    "subtype": "left",
    "id": "${homeState.userInfo.id}",
    "password": "${homeState.userInfo.password}",
    "version": "1.0"
  };
  var httpClient = HttpClient();
  httpClient
      .open("PUT", config.host, config.httpPort, "/user/offline")
      .then((request) {
    request.write(json.encode(req) + "\r\n");
    return request.close();
  }).then((response) {
    response.transform(utf8.decoder).listen((data) {
      var result = json.decode(data);
      var friends = result["friends"];
      var messages = result["messages"];
      if (friends != null && friends.length > 0) {
        for (var friend in friends) {
          homeState.systemInfoList.add(SystemInfoModel(
              type: "好友请求", info: friend["id"], to: friend["nickName"]));
        }
      }
      if (messages != null && messages.length > 0) {
        for (var message in messages) {
          homeState.userMessage
              .add(MessageListModel(name: message["id"], type: "message"));
        }
      }
    });
  });
}

///
/// 消息列表实体
/// @ name 发送消息方的id
/// @type  消息类型(message/inform)
/// @message 消息内容
///
///

class MessageListModel {
  String _name;
  String _type;
  String _message;

  MessageListModel({String name, String type, String message}) {
    this._name = name;
    this._type = type;
    this._message = message;
  }
}

///
///
/// 消息列表实体
///

class MessageListItem extends StatefulWidget {
  final String _name;
  final String _type;
  final String _message;
  final MyHomePageState homePageState;

  MessageListItem(this._name, this._type, this.homePageState, this._message);

  @override
  MessageListEntry createState() =>
      MessageListEntry(_name, _type, homePageState, _message);
}

class MessageListEntry extends State<MessageListItem> {
  final String _name;
  final String _type;
  final String _message;
  final MyHomePageState homePageState;

  MessageListEntry(this._name, this._type, this.homePageState, this._message);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: InputDecorator(
                decoration: InputDecoration(
                  icon: Icon(
                    _type == "message" ? Icons.message : Icons.notifications,
                    size: 40.0,
                  ),
                ),
              ),
              onPressed: () {},
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _name,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    _message,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            flex: 9,
          ),
        ],
      ),
      onTap: () {
        if (_type == "message") {
          homePageState.friendName = _name;
          homePageState.updateUi(3);
        } else {
          homePageState.updateUi(6);
        }
      },
    );
  }
}
///
///
/// 用户model
/// @id 用户名
/// @password 用户密码
///

class User {
  String id;
  String password;

  User({String id, String password}) {
    this.id = id;
    this.password = password;
  }
}
