import 'dart:io';

import 'package:flutter/material.dart';
import 'config/constants.dart' as constants;

class UserInterface extends StatefulWidget {
  @override
  UserInterfaceState createState() => UserInterfaceState();
}

class UserInterfaceState extends State<UserInterface> {

  var id = TextEditingController();
  var pw = TextEditingController();
  var nickname = TextEditingController();
  var friends = [];
  var notifications = [];

  int index = -1;

  Socket socket;

  @override
  Widget build(BuildContext context) {
    if (index < 0) {
      final Map arguments = ModalRoute
        .of(context)
        .settings
        .arguments;
      id.text = arguments[constants.id];
      pw.text = arguments[constants.password];
      nickname.text = arguments[constants.nickname];
      friends = arguments[constants.friends];
      notifications = arguments[constants.notifications];
      index = 0;

      Future<Socket> future = Socket.connect(constants.server, constants.tcpPort);
      future.then((socket) {
        this.socket = socket;
        socket.forEach((packet) {
          print(packet);
        });
        socket.done.then((_) => Navigator.popUntil(context, ModalRoute.withName('/')));
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("好友列表"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: InputDecorator(
              decoration: InputDecoration(icon: Icon(Icons.search)),
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/search", arguments: {constants.id: id.text.trim(), constants.password: pw.text.trim()});
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: showDrawer(),
      ),
      body: getBody(friends ??= [], notifications ??= []),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            title: Text("消息"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box), title: Text("好友")),
        ],
        onTap: (index) => setState(() => this.index = index),
        currentIndex: index,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    id.dispose();
    pw.dispose();
    nickname.dispose();
    if (this.socket != null) {
      socket.destroy();
    }
  }

  showDrawer() {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 100.0,
                height: 100.0,
                child: Image.asset("assets/images/flutter.png"),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          Text(
            nickname.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: "微软雅黑",
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_upload), title: Text("更新")),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app), title: Text("退出"))
        ],
        onTap: (value) {
          if (value == 1) {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          } else {
            setState(() {

            });
          }
        },
        currentIndex: 1,
      ),
    );
  }

  Column getBody(List friends, List notifications) {
    List<Widget> list = [];

    for (int i = 0; i < (index == 0 ? friends.length : notifications.length); i++) {
      var row;
      if (index == 0) {
        String id = friends[i][constants.id];

        row = Row(
          children: <Widget>[
            Icon(Icons.account_box),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(id + "(${friends[i][constants.nickname]})"),
                    Text("无消息")
                  ],
                ),
              ),
            ),
          ],
        );
      } else {
        row = Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              padding: EdgeInsets.all(10.0),
              onPressed: () {
                var message = {
                  constants.type: constants.friend,
                  constants.subtype: constants.response,
                  constants.to: notifications[i][constants.from],
                  constants.accept: true,
                  constants.version: constants.currentVersion
                };
                //todo send message to server
                setState(() {
                  notifications.removeAt(i);
                });
              },
              child: Text("接受"),
            ),
            RaisedButton(
              padding: EdgeInsets.all(10.0),
              onPressed: () {
                var message = {
                  constants.type: constants.friend,
                  constants.subtype: constants.response,
                  constants.to: notifications[i][constants.from],
                  constants.accept: false,
                  constants.version: constants.currentVersion
                };
                //todo send message to server
                setState(() {
                  notifications.removeAt(i);
                });
              },
              child: Text("拒绝"),
            ),
          ],
        );
      }

      var container = Container(
        padding: EdgeInsets.all(10.0),
        child: row,
      );

      var gestureDetector = GestureDetector(
        onTap: () {
          print('test');
        },
        child: container,
      );

      list.add(gestureDetector);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: list,
    );
  }
}