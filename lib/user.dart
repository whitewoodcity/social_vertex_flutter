import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'component/application_menu.dart';
import 'main.dart';
import 'config/constants.dart' as constants;

Widget showUser(MyHomePageState state) {

  int currentPage = state.currentPage == constants.userPage ? 1:0;

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
      padding: EdgeInsets.all(10.0),
      itemBuilder: (BuildContext context, int index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(Icons.notifications_active),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(state.offlineRequests[index][constants.from]),
                        Text(state.offlineRequests[index][constants.message])
                      ],
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  onPressed: () {
                    var response = {
                      constants.type: constants.friend,
                      constants.subtype: constants.response,
                      constants.to: state.offlineRequests[index][constants.from],
                      constants.accept: true,
                      constants.version: constants.currentVersion
                    };
                    state.sendMessage(json.encode(response));
                    state.offlineRequests.removeAt(index);
                    state.updateCurrentUI();
                  },
                  child: Text("接受"),
                ),
                RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  onPressed: () {
                    var response = {
                      constants.type: constants.friend,
                      constants.subtype: constants.response,
                      constants.to: state.offlineRequests[index][constants.from],
                      constants.accept: false,
                      constants.version: constants.currentVersion
                    };
                    state.sendMessage(json.encode(response));
                    state.offlineRequests.removeAt(index);
                    state.updateCurrentUI();
                  },
                  child: Text("拒绝"),
                ),
              ],
            ),
          ],
        );
      },
      itemCount: state.offlineRequests.length,
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
          state.updateUi(constants.userPage);
        }else{
          state.updateUi(constants.messagePage);
        }
      },
      currentIndex: currentPage,
    ),
  );
}
