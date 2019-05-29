import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dialog.dart';
import 'component/application_menu.dart';
import 'main.dart';
import 'config/constants.dart' as constants;

Widget showUser(MyHomePageState state) {
  var i = state.currentPage == constants.userPage ? 1 : 0;

  var title, content;

  if (i == 1) {
    title = "好友列表";
    content = ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemBuilder: (BuildContext context, int index) {
        String id = state.friends[index][constants.id];
        var row = Row(
          children: <Widget>[
            Icon(Icons.account_box),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(id + "(${state.friends[index][constants.nickname]})"),
                    Text("无消息")
                  ],
                ),
              ),
            ),
          ],
        );

        if (state.unreadMsgs.containsKey(id) && state.unreadMsgs[id] > 0) {
          row.children.add(
            Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.red,
                ),
                child: Text("${state.unreadMsgs[id]}",
                    style: TextStyle(color: Colors.white, fontSize: 15.0))),
          );
        }

        var widget = GestureDetector(
          onTap: () {
            state.friendId = state.friends[index][constants.id];
            state.friendNickname = state.friends[index][constants.nickname];
//            state.updateUI(constants.dialog);
            initChatDialog(state);
          },
          child: row,
        );

        return widget;
      },
      itemCount: state.friends.length,
    );
  } else {
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

                    state.friends.add({
                      constants.id: state.offlineRequests[index][constants.from]
                    });

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
            state.updateUI(constants.searchPage);
          },
        ),
      ],
    ),
    drawer: Drawer(
      child: showAppMenu(state),
    ),
    body: content,
    bottomNavigationBar: BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_active),
          title: Text("消息"),
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_box), title: Text("好友")),
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
