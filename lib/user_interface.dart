import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'config/constants.dart' as constants;

class UserInterface extends StatefulWidget {
  @override
  UserInterfaceState createState() => UserInterfaceState();
}

enum UserRoute{
  init, friends, notifications, dialog,
}

class UserInterfaceState extends State<UserInterface> {

  var id = TextEditingController();
  var pw = TextEditingController();
  var nickname = TextEditingController();
  var friends = [];
  var notifications = [];
  var friendId = "";
  var friendNickname = "";
  var dialogTtileController = TextEditingController();
  var scrollController = ScrollController();
  var messages = [];

  var userRoute = UserRoute.init;

  Socket socket;
  var httpClient = HttpClient();

  @override
  Widget build(BuildContext context) {
    if (userRoute == UserRoute.init) {
      final Map arguments = ModalRoute
        .of(context)
        .settings
        .arguments;
      id.text = arguments[constants.id];
      pw.text = arguments[constants.password];
      nickname.text = arguments[constants.nickname];
      friends = arguments[constants.friends];
      notifications = arguments[constants.notifications];
      userRoute = UserRoute.friends;

      scrollController.addListener(
          () {
          double maxScroll = scrollController.position.maxScrollExtent;
          double currentScroll = scrollController.position.pixels;
          double delta = 100.0; // or something else..
          if ( currentScroll - maxScroll >= delta) { // whatever you determine here
            //todo send message history request to the server
          }
        }
      );

      Socket.connect(constants.server, constants.tcpPort)
        .then((socket) {
        this.socket = socket;
        var msg = {
          constants.type: constants.login,
          constants.id: id.text.trim(),
          constants.password: pw.text.trim(),
          constants.version: constants.currentVersion,
        };
        socket.write(json.encode(msg) + constants.end);
        var message = List<int>();
        socket.forEach((packet) {
          message.addAll(packet); //粘包
          if (utf8.decode(message).endsWith(constants.end)) {
            List<String> msgs = utf8.decode(message).trim().split(constants.end); //拆包
            for (String msg in msgs) {
              processMesssage(msg);
            }
            message.clear();
          }
        });
        var ctx = Navigator.of(context);
        socket.handleError(() => ctx.popUntil(ModalRoute.withName('/')));
        socket.done.then((_) => ctx.popUntil(ModalRoute.withName('/')));
      });
    }

    if(userRoute==UserRoute.dialog){

      ListView dialog = ListView.builder(
        padding: EdgeInsets.all(10.0),
        controller: scrollController,
        itemBuilder: (BuildContext context, int index) {
          Map item = messages[index];

          var textAlign = TextAlign.start;
          if(item[constants.from] == id.text.trim()){
            textAlign = TextAlign.end;
          }

          var text = "";
//      if(item[constants.date]!=null && item[constants.time]!=null){
//        text += "${item[constants.date]} ${item[constants.time]}\n";
//      }
          text += "${item[constants.id]}:\n${item[constants.body]}";

          var row = Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("$text", textAlign: textAlign,),
                ),
              ),
            ],
          );

          if(item[constants.id] == id.text.trim()){
            row.children.add(Icon(Icons.message));
          }else{
            row.children.insert(0, Icon(Icons.message));
          }

          return row;
        },
        itemCount: messages.length,
      );

      return Scaffold(
        appBar: AppBar(
          title: Text("$friendId($friendNickname)"),
          centerTitle: true,
          leading: IconButton(
            icon: InputDecorator(
              decoration: InputDecoration(icon: Icon(Icons.arrow_back)),
            ),
            onPressed: () => setState(()=>userRoute=UserRoute.friends),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: dialog,
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {

                      },
                      controller: dialogTtileController,
                    ),
                  ),
                  RaisedButton(
                    child: Text("发送"),
                    onPressed: () {
                      var message = {
                        constants.type: constants.message,
                        constants.subtype: constants.text,

                      };

                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }else {
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
          child: getDrawer(),
        ),
        body: getBody(friends ??= [], notifications ??= []),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box), title: Text("好友")),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active), title: Text("消息"),
            ),
          ],
          onTap: (index) => setState(() => userRoute = index==0?UserRoute.friends:UserRoute.notifications),
          currentIndex: userRoute==UserRoute.friends?0:1,
        ),
      );
    }
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
    httpClient.close(force: true);
    scrollController.dispose();
    dialogTtileController.dispose();
  }

  processMesssage(String msg) {
    Map map = json.decode(msg);
    switch (map[constants.type]) {
      case constants.friend:
        switch (map[constants.subtype]) {
          case constants.request:
            setState(() {
              notifications.removeWhere((e) => e[constants.id] == map[constants.id]);
              notifications.insert(0, map);
            });
            break;
          case constants.response:
            if (map.containsKey(constants.accept) && map[constants.accept]) {
              setState(() {
                friends.removeWhere((e) => e[constants.id] == map[constants.id]);
                friends.insert(0, {constants.id: map[constants.id], constants.nickname: map[constants.nickname]});
              });
            } else {
              this.showMessage("${map[constants.id]}拒绝了您的好友请求");
            }
            break;
        }
        break;
      default:
    }
    print(msg);
  }

  getDrawer() {
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

  ListView getBody(List friends, List notifications) {
    List<Widget> list = [];

    for (int i = 0; i < (userRoute == UserRoute.friends ? friends.length : notifications.length); i++) {
      var widget;
      if (userRoute == UserRoute.friends) {
        String id = friends[i][constants.id];
        String nickname = friends[i][constants.nickname];

        var row = Row(
          children: <Widget>[
            Icon(Icons.account_box),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(id + "($nickname})"),
                    Text("无消息")
                  ],
                ),
              ),
            ),
          ],
        );

        var container = Container(
          padding: EdgeInsets.all(10.0),
          child: row,
        );

        widget = GestureDetector(
          onTap: () {
            setState(() {
              userRoute = UserRoute.dialog;
              friendId = id;
              friendNickname = nickname;
            });
          },
          child: container,
        );
      } else {
        var upperRow = Row(
          children: <Widget>[
            Icon(Icons.notifications_active),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(notifications[i][constants.id]),
                    Text(notifications[i][constants.message])
                  ],
                ),
              ),
            )
          ],
        );

        void _pressed(bool accept) async {
          //define a function, used below
          var id = notifications[i][constants.id];
          var msg = {
            constants.type: constants.friend,
            constants.subtype: constants.response,
            constants.id: this.id.text.trim(),
            constants.password: this.pw.text.trim(),
            constants.nickname: this.nickname.text.trim(),
            constants.to: id,
            constants.accept: accept,
            constants.version: constants.currentVersion
          };
          httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
          var request = await httpClient.putUrl(Uri.parse("${constants.protocol}${constants.server}/${constants.search}"));
          request.headers.add("content-type", "application/json;charset=utf-8");
          request.write(json.encode(msg));
          var response = await request.close();
          if (response.statusCode == 200) {
            if (accept) {
              friends.removeWhere((e) => e[constants.id] == id);
              friends.insert(0, {constants.id: id, constants.nickname: this.nickname.text.trim()});
            }
            setState(() {
              notifications.removeWhere((e) => e[constants.id] == id);
            });
          } else {
            this.showMessage("服务器错误!");
          }
        }

        var lowerRow = Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              padding: EdgeInsets.all(10.0),
              onPressed: () => _pressed(true),
              child: Text("接受"),
            ),
            RaisedButton(
              padding: EdgeInsets.all(10.0),
              onPressed: () => _pressed(false),
              child: Text("拒绝"),
            ),
          ],
        );

        var col = Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[upperRow, lowerRow]);

        widget = Container(
          padding: EdgeInsets.all(10.0),
          child: col,
        );
      }

      list.add(widget);
    }

//    var col = Column(
//      crossAxisAlignment: CrossAxisAlignment.stretch,
//      children: list,
//    );

    return ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemBuilder: (BuildContext context, int index) => list[index],
      itemCount: list.length,
    );
  }

  void showMessage(String message) {
    //显示系统消息
    showDialog(
      context: context,
      builder: (BuildContext context) =>
        SimpleDialog(
//              title: Text("消息"),
          children: <Widget>[
            Center(
              child: Text(message),
            )
          ],
        ));
  }
}