import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'component/application_menu.dart';
import 'main.dart';
import 'config/constants.dart' as constants;

Widget showUser(MyHomePageState state) {

  var i = state.currentPage == constants.userPage ? 1:0;

  var title, content;

  if (i == 1){
    title = "好友列表";
    content = ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemBuilder: (BuildContext context, int index) {
        var widget = Row(
          children: <Widget>[
            Icon(Icons.message),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(state.friendList[index][constants.id] +
                        "(${state.friendList[index][constants.nickname]})"),
                    Text("无消息")
                  ],
                ),
              ),
            ),
          ],
        );

        widget.children.add(
          Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.red,
              ),
              child: Text("99+",
                  style: TextStyle(color: Colors.white, fontSize: 15.0))),
        );
        return widget;
      },
      itemCount: state.friendList.length,
    );
  }else {
    title = "消息列表";
    content = ListView.builder(
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
                      constants.to: state.offlineRequests[index]
                      [constants.from],
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
                      constants.to: state.offlineRequests[index]
                      [constants.from],
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
    );
  }

  return Scaffold(
    appBar: AppBar(
      title: Text(title),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: InputDecorator(
            decoration: InputDecoration(icon: Icon(Icons.add)),
          ),
          onPressed: () {
            state.updateUI(4);
          },
        ),
      ],
    ),
    drawer: Drawer(
      child: showAppMenu(state.nickname),
    ),
    body: content,
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
          state.updateUI(constants.userPage);
        } else {
          state.updateUI(constants.messagePage);
        }
      },
      currentIndex: i,
    ),
  );
}
