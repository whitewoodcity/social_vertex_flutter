import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'component/application_menu.dart';
import 'main.dart';
import 'message_list.dart';
import 'package:social_vertex_flutter/config/config.dart' as config;

MyHomePageState homeState;

Widget showUser(MyHomePageState state) {
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
    body: showMessageList(homeState),
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

void _obtainLeftMessage() {        /**todo 获取离线消息**/
  var httpClient = HttpClient();
  httpClient
      .open("POST", config.host, config.httpPort, "/user")
      .then((request) {

  });
}
