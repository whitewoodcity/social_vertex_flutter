import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_vertex_flutter/component/message_item.dart';
import 'user_info.dart';
import 'search.dart';
import 'dialog.dart';
import 'contact_list.dart';
import 'user.dart';
import 'login.dart';
import 'utils/keys.dart' as keys;
import 'config/config.dart' as config;

void main() => runApp(new MyApplication()); //整个应用的入口

class MyApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      new MaterialApp(title: "IM通讯", home: new MyHomePage());
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  var context;
  var curPage = 100;
  var friendName;
  Socket _socket;
  List<Entry> list = []; //好友列表
  String userName; //用户名
  List<MessageEntry> messageList = []; //消息列表
  List<SearchItem> searchList = []; //搜索好友列表
  String           searchKey;
  List<UserInfoItem>     userInfoList=[new UserInfoItem(new UserInfoModel(id:'ZXJ2017',name: "哲学家" ),),];

  Widget build(BuildContext context) {
    this.context = context;
    switch (curPage) {
      case keys.user:
        return showUser(this);
      case keys.contacts:
        return showContacts(this, list);
      case keys.dialog:
        return showChatDialog(friendName, this, messageList);
      case keys.search:
        return showSearchDialog(this, searchList);
      case keys.userInfo:
        return showInfo(this,searchKey,userInfoList);
      default:
        return showLogin(this);
    }
  }

  void showMesssge(String message) {
    //显示系统消息
    showDialog(
        context: context,
        builder: (BuildContext context) => new SimpleDialog(
              title: new Text("消息"),
              children: <Widget>[
                new Center(
                  child: new Text(message),
                )
              ],
            ));
  }

  void updateUi(int index) {
    //切换页面
    print(index);
    setState(() {
      curPage = index;
    });
  }

  void showChat(String name) {
    //显示聊天对框
    setState(() {
      curPage = 3;
      friendName = name;
    });
  }
  void showUserInfo(int status,String keyWord){  //显示search界面
    setState(() {
      curPage = status;
      searchKey = keyWord;
    });

  }

  /*
  处理Socket事件
   */

  initConnect() async {
    if (_socket != null) {
      _socket.destroy();
    }
    _socket = await Socket.connect(config.host, config.tcpPort);
    _socket.forEach(
      (package) {
        var backInf = json.decode(utf8.decode(package));
        var type = backInf["type"];
        print(backInf);
        switch (type) {
          case "user": //登录
            bool loginStatus = backInf["login"];
            if (loginStatus) {
              userName = backInf["user"]["id"];
              this.updateUi(1);
            } else {
              this.showMesssge(backInf['info']);
            }
            break;
          case "friend": //获取好友列表
            if (backInf["action"] == "list") {
              List<Entry> result = [];
              var groups = backInf["results"];
              for (var group in groups) {
                List<Entry> friends = new List();
                var lists = group["lists"];
                print(lists);
                for (var friend in lists) {
                  friends.add(new Entry(friend["nickname"]));
                }
                result.add(new Entry(group["group"], friends));
              }
              if (result.length > 0) {
                updateContactsList(result);
              } else {
                showMesssge("好友列表为空");
              }
            }
            if (backInf["action"] == "request") {
              showMesssge(backInf["info"]);
            }
            break;
          case "message": //获取消息
            var status = backInf["info"];
            if (status == "OK") {
              updateChartList(backInf["body"]);
            } else {
              showMesssge(backInf["info"]);
            }
            if (backInf["from"] != userName) updateChartList(backInf["body"]);
            break;
          case "search": //搜索好友
            if (backInf["user"] != null) {
              if (searchList.length != 0)
                searchList.removeRange(0, searchList.length);
              searchList.add(new SearchItem(backInf["user"]["user"]));
              updateSearchList();
            } else {
              showMesssge("该用户不存在，换个姿势试试！");
            }
            break;
        }
      },
    );
    try {
      _socket.done;
    } catch (error) {
      this.showMesssge("连接断开");
    }
  }

  void sendMessage(String message) {
    //向服务器发送数据
    print(message);
    _socket.write(message);
  }

  void updateContactsList(List<Entry> list) {
    //更新联系人列表
    setState(() {
      this.list = list;
    });
  }

  void updateChartList(String message) {
    //实时更新聊天信息
    setState(() {
      messageList = new List.from(messageList);
      messageList.add(new MessageEntry(message));
    });
  }

  void updateSearchList() {
    //更新搜索好友列表
    setState(() {
      searchList = new List.from(searchList);
    });
  }
}
