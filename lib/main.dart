import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'system_info.dart';
import 'component/message_item.dart';
import 'search.dart';
import 'dialog.dart';
import 'contact_list.dart';
import 'user.dart';
import 'login.dart';
import 'config/constants.dart' as constants;

void main() => runApp(MyApplication()); //整个应用的入口

class MyApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "IM通讯",
        home: MyHomePage(),
        theme: constants.applicationTheme,
      );
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  var context;
  var currentPage = 100;

  String id;
  String password;
  Socket _socket;

  String friendName;
  List<Entry> list = []; //好友列表
  String userName; //用户名
  List<MessageEntry> messageList = []; //聊天消息列表
  List<SearchItem> searchList = []; //搜索好友列表
  List<MessageListModel> userMessage = []; //消息列表
  List<SystemInfoModel> systemInfoList = [];

  String searchKey;
  String curChartTarget; //当前聊天对象

  Widget build(BuildContext context) {
    this.context = context;
    switch (currentPage) {
      case constants.userPage:
        return showUser(this);
      case constants.contacts:
        return showContacts(this);
      case constants.dialog:
        return showChatDialog(friendName, this);
      case constants.searchPage:
        return showSearchDialog(this);
      case constants.systemPage:
        return showSystemInfo(this);
      default:
        return showLogin(this);
    }
  }

  void showMessage(String message) {
    //显示系统消息
    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
//              title: Text("消息"),
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
                            constants.type: constants.friend,
                            constants.subtype: constants.response,
                            constants.to: to,
                            constants.accept: true,
                            constants.version: constants.currentVersion
                          };
                          sendMessage(json.encode(agree) + constants.end);
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
                            constants.type: constants.friend,
                            constants.subtype: constants.response,
                            constants.to: "$to",
                            constants.accept: false,
                            constants.version: constants.currentVersion
                          };
                          sendMessage(json.encode(refuse) + constants.end);
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
      currentPage = index;
    });
  }

  void showChat(String name) {
    //显示聊天对框
    setState(() {
      currentPage = 3;
      friendName = name;
    });
  }

  void showUserInfo(int status, String keyWord) {
    //显示search界面
    setState(() {
      currentPage = status;
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

    List<int> message = List<int>();

    try {
      _socket = await Socket.connect(constants.server, constants.tcpPort);
      _socket.forEach(
        (package) {
          message.addAll(package);//粘包
          if (utf8.decode(message).endsWith(constants.end)) {
            var backInf = json.decode(utf8.decode(message).trim());
            message.clear();

            print(backInf);
            var type = backInf[constants.type];
            print("返回消息：$backInf");
            switch (type) {
              case constants.user: //登录
                bool loginStatus = backInf[constants.login];
                if (loginStatus) {
                  userName = backInf[constants.id];
                  List<Entry> friends = List();

                  if (backInf[constants.friends].length > 0) {
                    for (var friend in backInf[constants.friends]) {
                      print(friend.runtimeType);
                      friends.add(Entry(friend[constants.nickname]));
                    }
                    list.add(Entry("我的好友", friends));
                  }
                  this.updateUi(1);
                } else {
                  this.showMessage(backInf[constants.info] == null
                      ? "登陆失败"
                      : backInf[constants.info]);
                }
                break;
              case constants.message: //获取消息
                if (curChartTarget == backInf[constants.from]) {
                  updateChartList(backInf[constants.body]);
                } else {
                  userMessage.add(MessageListModel(
                      name: backInf[constants.from],
                      type: backInf[constants.type],
                      message: backInf[constants.body]));
                }

                break;
              case constants.friend: //添加好友请求和回复
                var subtype = backInf[constants.subtype];
                if (subtype == constants.request) {
                  _showRequest(
                      backInf[constants.message], backInf[constants.from]);
                } else {
                  if (backInf[constants.accept]) {
                    _dynamicUpdataFriendList(backInf[constants.from]);
                  }
                }
                break;
            }
          }
        },
      );
      _socket.done;
    } catch (e) {
      message.clear();
      showMessage("网络异常!");
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

  void updateSearchList(String result) {
    //更新搜索好友列表
    setState(() {
      searchList = List.from(searchList);
      searchList.add(SearchItem(result, this));
    });
  }
}
