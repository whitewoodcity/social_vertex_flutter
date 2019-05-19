import 'dart:io';

import 'package:flutter/material.dart';
import 'config/constants.dart' as constants;

class UserInterface extends StatefulWidget {
  @override
  UserInterfaceState createState() => UserInterfaceState();
}

class UserInterfaceState extends State<UserInterface> {

  TextEditingController id = TextEditingController();
  TextEditingController pw = TextEditingController();
  TextEditingController nickname = TextEditingController();
  List friends = [];
  List notifications = [];

  int index = -1;

  Socket socket;

  @override
  Widget build(BuildContext context) {
    if(index<0){
      final Map arguments = ModalRoute.of(context).settings.arguments;
      id.text = arguments[constants.id];
      pw.text = arguments[constants.password];
      nickname.text = arguments[constants.nickname];
      friends = arguments[constants.friends];
      notifications = arguments[constants.notifications];
      index = 0;

      Future<Socket> future = Socket.connect(constants.server, constants.tcpPort);
      future.then((socket){
        this.socket = socket;
        socket.forEach((packet){ print(packet);});
        socket.done.then((_)=> Navigator.popUntil(context, ModalRoute.withName('/')));
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("好友列表"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: InputDecorator(
              decoration: InputDecoration(icon: Icon(Icons.add)),
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/search", arguments: "test");
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: showDrawer(),
      ),
      body: showFriendList(friends),
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
    if(this.socket!=null){
      socket.destroy();
    }
  }

  showDrawer() {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 100.0,
                  child: Image.asset("assets/images/flutter.png"),
                ),
              ],
            ),
            color: Colors.blue,
            height: 100.0,
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
          print(value);
          if(value == 1){
            Navigator.popUntil(context, ModalRoute.withName('/'));
          }
        },
        currentIndex: 1,
      ),
    );
  }

  Widget showFriendList(List friends){
    return ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemBuilder: (BuildContext context, int index) {
        String id = friends[index][constants.id];
        var row = Row(
          children: <Widget>[
            Icon(Icons.account_box),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(id + "(${friends[index][constants.nickname]})"),
                    Text("无消息")
                  ],
                ),
              ),
            ),
          ],
        );

        if (false) {//state.unreadMsgs.containsKey(id) && state.unreadMsgs[id] > 0
          row.children.add(
            Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.red,
              ),
              child: Text(" ",
                style: TextStyle(color: Colors.white, fontSize: 15.0))),
          );
        }

        var widget = GestureDetector(
          onTap: () {
//            state.friendId = state.friends[index][constants.id];
//            state.friendNickname = state.friends[index][constants.nickname];
////            state.updateUI(constants.dialog);
//            initChatDialog(state);
          },
          child: row,
        );

        return widget;
      },
      itemCount: friends.length,
    );
  }

  Widget showNotificationList(List notifications){
    ListView.builder(
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
                        Text(notifications[index][constants.from]),
                        Text(notifications[index][constants.message])
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
                      constants.to: notifications[index]
                      [constants.from],
                      constants.accept: true,
                      constants.version: constants.currentVersion
                    };
//                    state.sendMessage(json.encode(response));

                    friends.add({
                      constants.id: notifications[index][constants.from]
                    });

                    notifications.removeAt(index);

//                    state.updateCurrentUI();
                  },
                  child: Text("接受"),
                ),
                RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  onPressed: () {
                    var response = {
                      constants.type: constants.friend,
                      constants.subtype: constants.response,
                      constants.to: notifications[index]
                      [constants.from],
                      constants.accept: false,
                      constants.version: constants.currentVersion
                    };
//                    state.sendMessage(json.encode(response));
//                    state.offlineRequests.removeAt(index);
//                    state.updateCurrentUI();
                  },
                  child: Text("拒绝"),
                ),
              ],
            ),
          ],
        );
      },
      itemCount: notifications.length,
    );
  }
}