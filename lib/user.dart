import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'component/application_menu.dart';
import 'main.dart';
import 'package:social_vertex_flutter/config/config.dart' as config;

MyHomePageState homeState;

Widget showUser(MyHomePageState state, List<MessageListModel> list) {
  homeState = state;

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
      itemBuilder: (BuildContext context, int index) =>
          MessageListItem(list[index]._name,list[index]._type,homeState),
      itemCount: list.length,
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
  /**todo 获取离线消息**/
  var httpClient = HttpClient();
  httpClient
      .open("POST", config.host, config.httpPort, "/user")
      .then((request) {});
}

class MessageListModel{
   String _name;
   String _type;

  MessageListModel({String name,String type}){
    this._name = name;
    this._type=type;
  }

}

///
///
/// 消息列表实体
///

class MessageListItem extends StatefulWidget {
  final String _name;
  final String _type;
  final MyHomePageState homePageState;

  MessageListItem(this._name, this._type,this.homePageState);

  @override
  MessageListEntry createState() => MessageListEntry(_name, _type,homePageState);
}

class MessageListEntry extends State<MessageListItem> {
  final String _name;
  final String _type;
  final MyHomePageState homePageState;

  MessageListEntry(this._name, this._type,this.homePageState);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        children: <Widget>[
          Expanded(
            child: IconButton(
              icon: InputDecorator(
                decoration: InputDecoration(
                  icon: Icon(
                    _type=="message"?Icons.message:Icons.notifications,
                    size: 40.0,
                  ),
                ),
              ),
              onPressed: () {},
            ),
            flex: 1,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(_name),
            ),
            flex: 9,
          ),
        ],
      ),
      onTap: () {
        if(_type=="message"){
          homePageState.friendName=_name;
          homePageState.updateUi(3);
        }else{
          homePageState.updateUi(6);
        }
      },
    );
  }
}
