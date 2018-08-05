import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'system_info.dart';
import 'component/message_item.dart';
import 'user_info.dart';
import 'search.dart';
import 'dialog.dart';
import 'contact_list.dart';
import 'user.dart';
import 'login.dart';
import 'utils/keys.dart' as keys;
import 'config/config.dart' as config;

void main() => runApp(MyApplication()); //整个应用的入口

class MyApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      MaterialApp(title: "IM通讯", home: MyHomePage());
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  var context;
  var curPage = 100;
  var friendName;
  Socket _socket;
  List<Entry> list = []; //好友列表
  String userName; //用户名
  List<MessageEntry> messageList = []; //聊天消息列表
  List<SearchItem> searchList = []; //搜索好友列表
  List<MessageListModel> userMessage = [   //消息列表
    MessageListModel(name: "yangkui", type: "message"),
    MessageListModel(name: "系统消息", type: "friend")
  ];
  List<SystemInfoModel> systemInfoList =[
    SystemInfoModel(type: "好友请求",info:"我是yangkui请求加你为好友",to: "yangxiong")
  ];

  String searchKey;
  String curChartTarget; //当前聊天对象

  List<UserInfoItem> userInfoList = [
    UserInfoItem(
      UserInfoModel(id: 'ZXJ2017', name: "哲学家"),
    ),
  ];

  Widget build(BuildContext context) {
    this.context = context;
    switch (curPage) {
      case keys.user:
        return showUser(this, userMessage);
      case keys.contacts:
        return showContacts(this, list);
      case keys.dialog:
        return showChatDialog(friendName, this, messageList);
      case keys.search:
        return showSearchDialog(this, searchList);
      case keys.userInfo:
        return showInfo(this, searchKey, userInfoList);
      case keys.systemInfo:
        return showSystemInfo(this,systemInfoList);
      default:
        return showLogin(this);
    }
  }

  void showMessage(String message) {
    //显示系统消息
    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: Text("消息"),
              children: <Widget>[
                Center(
                  child: Text(message),
                )
              ],
            ));
  }

  void _showRequest(String message, String to) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => SimpleDialog(
            title: Text("好友请求"),
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        height: 100.0,
                        alignment: Alignment.center,
                        child: Text(
                          message,
                          style: TextStyle(fontSize: 18.0),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          var agree = {
                            "type": "friend",
                            "subtype": "response",
                            "to": "$to",
                            "accept": true,
                            "version": "0.1"
                          };
                          sendMessage(json.encode(agree) + "\r\n");
                          _dynamicUpdataFriendList(to);
                          Navigator.pop(context);
                        },
                        child: Text("接受"),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      RaisedButton(
                        onPressed: () {
                          var refuse = {
                            "type": "friend",
                            "subtype": "response",
                            "to": "$to",
                            "accept": false,
                            "version": "0.1"
                          };
                          sendMessage(json.encode(refuse) + "\r\n");
                          Navigator.pop(context);
                        },
                        child: Text("拒绝"),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
    );
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

  void showUserInfo(int status, String keyWord) {
    //显示search界面
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
        var backInf = json.decode(utf8.decode(package).trim());
        var type = backInf["type"];
        print("返回消息：$backInf");
        switch (type) {
          case "user": //登录
            bool loginStatus = backInf["login"];
            if (loginStatus) {
              userName = backInf["id"];
              List<Entry> friends = List();

              if (backInf["friends"].length > 0) {
                for (var friend in backInf["friends"]) {
                  print(friend.runtimeType);
                  friends.add(Entry(friend["nickname"]));
                }
                list.add(Entry("我的好友", friends));
              }
              this.updateUi(1);
            } else {
              this.showMessage(
                  backInf['info'] == null ? "登陆失败" : backInf["info"]);
            }
            break;
          case "message": //获取消息

            if (curChartTarget == backInf["from"]) {
              updateChartList(backInf["body"]);
            } else {
              /**todo 更新到消息列表中去**/

            }

            break;
          case "search": //搜索好友
            if (backInf["info"] != null) {
              if (searchList.length != 0)
                searchList.removeRange(0, searchList.length);
              searchList.add(SearchItem(backInf["info"]["id"]));
              updateSearchList();
            } else {
              showMessage("该用户不存在，换个姿势试试！");
            }
            break;
          case "friend": //添加好友请求和回复
            var subtype = backInf["subtype"];
            if (subtype == "request") {
              _showRequest(backInf["message"], backInf["from"]);
            } else {
              if (backInf["accept"]) {
                _dynamicUpdataFriendList(backInf["from"]);
              }
            }
            break;
        }
      },
    );
    try {
      _socket.done;
    } catch (error) {
      this.showMessage("连接断开");
    }
  }

  void _dynamicUpdataFriendList(String nickName) {
    //更新好友列表
    list = List.from(list);
    if (list.length > 0) {
      list.first.list.add(Entry(nickName));
    } else {
      List<Entry> friend = List();
      friend.add(Entry(nickName));
      list.add(Entry("我的好友", friend));
    }
    setState(() {
      this.list = list;
    });
  }

  void sendMessage(String message) {
    //向服务器发送数据
    print(message);
    _socket.write(message);
  }

  void updateChartList(String message) {
    //实时更新聊天信息
    setState(() {
      messageList = List.from(messageList);
      messageList.add(MessageEntry(message));
    });
  }

  void updateSearchList() {
    //更新搜索好友列表
    setState(() {
      searchList = List.from(searchList);
    });
  }
}
