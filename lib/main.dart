import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_vertex_flutter/utils/util.dart';
import 'system_info.dart';
import 'search.dart';
import 'dialog.dart';
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

  String id = "";
  String password = "";
  Socket _socket;
  String nickname; //昵称

  List offlineRequests = []; //离线好友请求列表
  List friends = []; //好友列表

  String friendId = "";
  String friendNickname = "";
  Map<String, List> messages = {};

  List<SystemInfoModel> systemInfoList = [];

  String searchKey;

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
              currentPage == constants.messagePage) {
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
      case constants.dialog:
        return showChatDialog(this);
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

  void updateUI(int index) {
    //切换页面
    lastPage = currentPage;
    setState(() {
      currentPage = index;
    });
  }

  void updateCurrentUI() {
    //切换页面
    setState(() {});
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

//    RawSecureSocket rss = await RawSecureSocket.connect("", 1234, onBadCertificate: (cer){return true;});

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
          if (backInf[constants.friends] != null) {
            friends = backInf[constants.friends];
          }
          this.updateUI(constants.userPage);

          _obtainOfflineMessages();
        } else {
          this.showMessage(backInf[constants.info] == null
              ? "登陆失败"
              : backInf[constants.info]);
        }
        break;
      case constants.message: //获取消息
        var sender = backInf[constants.from];
        if (!messages.containsKey(sender)) {
          messages[sender] = [];
        }
        messages[sender].add(backInf);
        updateCurrentUI();
        break;
      case constants.friend: //添加好友请求和回复
        var subtype = backInf[constants.subtype];
        if (subtype == constants.request) {
          offlineRequests.add(backInf);
          updateCurrentUI();
        } else if (subtype == constants.response) {
          if (backInf[constants.accept]) {
            friends.add({
              constants.id: backInf[constants.from],
            });
            updateCurrentUI();
          } else {
            showMessage(backInf[constants.from] + "拒绝加你为好友！");
          }
        }
        break;
    }
  }

  void sendMessage(String message) {
    //向服务器发送数据
    print(message);
    _socket.write(message + constants.end);
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
        Map result = json.decode(data);
        print(result.toString());
        offlineRequests.clear();
        if (result[constants.friends] != null)
          offlineRequests = result[constants.friends];

        if (result.containsKey(constants.messages)) {
          for (Map message in result[constants.messages]) {
            var sender = message[constants.from];
            if (!messages.containsKey(sender)) {
              messages[sender] = [];
            }
            messages[sender].add(message);
          }
        }
        updateCurrentUI();
      });
    });
  }
}
