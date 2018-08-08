import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_vertex_flutter/utils/util.dart';
import 'system_info.dart';
import 'component/application_menu.dart';
import 'main.dart';
import 'config/constants.dart' as constants;

bool isObtainLeft = false;

Widget showUser(MyHomePageState state) {
  if (!isObtainLeft) _obtainLeftMessage(state);

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
            state.updateUi(4);
          },
        ),
      ],
    ),
    drawer: Drawer(
      child: showAppMenu(state.nickname),
    ),
    body: ListView.builder(
      itemBuilder: (BuildContext context, int index) => MessageListItem(
          state.userMessage[index]._name,
          state.userMessage[index]._type,
          state,
          state.userMessage[index]._message),
      itemCount: state.userMessage.length,
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

void _obtainLeftMessage(MyHomePageState state) {
  var req = {
    constants.id: state.id,
    constants.password: md5(state.password),
    constants.version: constants.currentVersion
  };
  var httpClient = HttpClient();
  httpClient
      .open("PUT", constants.server, constants.httpPort,
          "/${constants.user}/${constants.offline}")
      .then((request) {
    request.write(json.encode(req) + constants.end);
    return request.close();
  }).then((response) {
    response.transform(utf8.decoder).listen((data) {
      var result = json.decode(data);
      print(result.toString());
      var friends = result[constants.friends];
      var messages = result[constants.messages];
      if (friends != null && friends.length > 0) {
        var isExist = false;
        for (var friend in friends) {
          for (var item in state.systemInfoList) {
            if (item.info == friend[constants.message]) {
              isExist = true;
              break;
            }
          }
          if (!isExist) {
            state.systemInfoList.add(SystemInfoModel(
                type: "好友请求",
                info: friend[constants.message],
                to: friend[constants.nickname]));
          }
        }
        state.userMessage.add(
            MessageListModel(name: "系统消息", type: "inform", message: "好友请求"));
      }
      if (messages != null && messages.length > 0) {
        var isExist = false;
        for (var message in messages) {
          if (state.userMessage.length > 0) {
            for (var item in state.userMessage) {
              if (item._name == message["from"]) {
                isExist = true;
                break;
              }
            }
          }
          if (!isExist) {
            state.userMessage.add(MessageListModel(
                name: message["from"],
                type: message["type"],
                message: message["body"]));
          }
        }
      }
      isObtainLeft = true;
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: InputDecorator(
                  decoration: InputDecoration(
                    icon: Icon(
                      _type == constants.message
                          ? Icons.message
                          : Icons.notifications,
                      size: 40.0,
                    ),
                  ),
                ),
                onPressed: () {},
              ),
            ),
            flex: 1,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _name,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    _message == null ? "???" : _message,
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
        if (_type == constants.message) {
          homePageState.friendName = _name;
          homePageState.updateUi(3);
        } else {
          homePageState.updateUi(5);
        }
      },
    );
  }
}
