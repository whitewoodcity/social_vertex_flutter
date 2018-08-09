import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_vertex_flutter/utils/util.dart';
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
  var controller;
  var currentPage = 100;

  Animation<double> animation;
  int lastPage = 0;

  String id;
  String password;
  Socket _socket;
  String nickname; //昵称

  List offlineRequests = [];//离线好友请求列表
  List friendList = [];

  String friendName;
  List<Entry> friends = []; //好友列表
  List<MessageEntry> messageList = []; //聊天消息列表
  List<SearchItem> searchList = []; //搜索好友列表
//  List<MessageListModel> userMessage = []; //消息列表
  List<SystemInfoModel> systemInfoList = [];

  String searchKey;
  String curChartTarget;

  @override
  void dispose() {
    super.dispose();
    if (_socket != null) _socket.close();
    exit(1);
  }

  Widget build(BuildContext context) {
    this.context = context;
    var widget = WillPopScope(
        child: _changePage(),
        onWillPop: () {
          if (currentPage == constants.userPage ||
              currentPage == constants.contacts) {
            updateUI(constants.loginPage);
          } else if (currentPage == constants.loginPage) {
            this.dispose();
          } else {
            updateUI(lastPage);
          }
        });
    return widget;
  }

  Widget _changePage() {
    switch (currentPage) {
      case constants.userPage:
      case constants.messagePage:
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

//  void _showRequest(String message, String to) {
//    showDialog(
//      context: context,
//      barrierDismissible: false,
//      builder: (BuildContext context) => SimpleDialog(
//            title: Text("好友请求"),
//            children: <Widget>[
//              Column(
//                children: <Widget>[
//                  Row(
//                    children: <Widget>[
//                      Container(
//                        height: 100.0,
//                        alignment: Alignment.center,
//                        child: Text(
//                          message,
//                          style: TextStyle(fontSize: 18.0),
//                          overflow: TextOverflow.ellipsis,
//                        ),
//                      ),
//                    ],
//                  ),
//                  Row(
//                    children: <Widget>[
//                      SizedBox(
//                        height: 10.0,
//                      )
//                    ],
//                  ),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      RaisedButton(
//                        onPressed: () {
//                          var agree = {
//                            constants.type: constants.friend,
//                            constants.subtype: constants.response,
//                            constants.to: to,
//                            constants.accept: true,
//                            constants.version: constants.currentVersion
//                          };
//                          sendMessage(json.encode(agree) + constants.end);
//                          _dynamicUpdataFriendList(to);
//                          Navigator.pop(context);
//                        },
//                        child: Text("接受"),
//                      ),
//                      SizedBox(
//                        width: 10.0,
//                      ),
//                      RaisedButton(
//                        onPressed: () {
//                          var refuse = {
//                            constants.type: constants.friend,
//                            constants.subtype: constants.response,
//                            constants.to: "$to",
//                            constants.accept: false,
//                            constants.version: constants.currentVersion
//                          };
//                          sendMessage(json.encode(refuse) + constants.end);
//                          Navigator.pop(context);
//                        },
//                        child: Text("拒绝"),
//                      ),
//                    ],
//                  ),
//                ],
//              ),
//            ],
//          ),
//    );
//  }

  void updateUI(int index) {
    //切换页面
    lastPage = currentPage;
    setState(() {
      currentPage = index;
    });
  }

  void updateCurrentUI() {
    //切换页面
    setState(() {

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
          message.addAll(package); //粘包
          if (utf8.decode(message).endsWith(constants.end)) {
            List<String> msgs =
                utf8.decode(message).trim().split(constants.end);
            for (String msg in msgs) {
              processMessage(msg);
            }
            message.clear();
          }
        },
      );
      _socket.done;
    } catch (e) {
      message.clear();
      showMessage("网络异常!");
    }
  }

  void processMessage(String message) {
    var backInf = json.decode(message);
    var type = backInf[constants.type];
    print("返回消息：$backInf");
    switch (type) {
      case constants.user: //登录
        bool loginStatus = backInf[constants.login];
        if (loginStatus) {
          nickname = backInf[constants.nickname] == null
              ? backInf[constants.id]
              : backInf[constants.nickname];
          if(backInf[constants.friends]!=null){
            friendList = backInf[constants.friends];
          }
//          List<Entry> friends = List();
//
//          if (backInf[constants.friends].length > 0) {
//            for (var friend in backInf[constants.friends]) {
//              friends.add(Entry(friend[constants.nickname]));
//            }
//            this.friends.add(Entry("我的好友", friends));
//          }
          this.updateUI(constants.userPage);

          _obtainOfflineMessages();
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
//          userMessage.add(MessageListModel(
//              name: backInf[constants.from],
//              type: backInf[constants.type],
//              message: backInf[constants.body]));
        }

        break;
      case constants.friend: //添加好友请求和回复
        var subtype = backInf[constants.subtype];
        if (subtype == constants.request) {
//          _showRequest(backInf[constants.message], backInf[constants.from]);
        } else {
          if (backInf[constants.accept]) {
            _dynamicUpdataFriendList(backInf[constants.from]);
          } else {
            showMessage(backInf[constants.from] + "拒绝加你为好友！");
          }
        }
        break;
    }
  }

  void _dynamicUpdataFriendList(String nickName) {
    //更新好友列表
    friends = List.from(friends);
    if (friends.length > 0) {
      friends.first.list.add(Entry(nickName));
    } else {
      List<Entry> friend = List();
      friend.add(Entry(nickName));
      friends.add(Entry("我的好友", friend));
    }
    setState(() {
      this.friends = friends;
    });
  }

  void sendMessage(String message) {
    //向服务器发送数据
    print(message);
    _socket.write(message+constants.end);
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

  void _obtainOfflineMessages() {
    var req = {
      constants.id: id,
      constants.password: md5(password),
      constants.version: constants.currentVersion
    };
    var httpClient = HttpClient();
    httpClient
        .put(constants.server, constants.httpPort,
            "/${constants.user}/${constants.offline}")
        .then((request) {
      request.write(json.encode(req) + constants.end);
      return request.close();
    }).then((response) {
      response.transform(utf8.decoder).listen((data) {
        var result = json.decode(data);
        print(result.toString());
        offlineRequests.clear();
        if(result[constants.friends]!=null)
          offlineRequests = result[constants.friends];
        var messages = result[constants.messages];

        updateCurrentUI();
      });
    });
  }
}
