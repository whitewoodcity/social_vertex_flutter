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

  String searchKey;
  String curChartTarget;            //当前聊天对象

  List<UserInfoItem> userInfoList = [
    new UserInfoItem(
      new UserInfoModel(id: 'ZXJ2017', name: "哲学家"),
    ),
  ];

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
        return showInfo(this, searchKey, userInfoList);
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

  void _showRequest(String message, String to) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => new SimpleDialog(
            title: new Text("好友请求"),
            children: <Widget>[
              new Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Container(
                        height: 100.0,
                        alignment: Alignment.center,
                        child: new Text(
                          message,
                          style: TextStyle(fontSize: 18.0),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new SizedBox(
                        height: 10.0,
                      )
                    ],
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new RaisedButton(
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
                        child: new Text("接受"),
                      ),
                      new SizedBox(
                        width: 10.0,
                      ),
                      new RaisedButton(
                        onPressed: () {
                          var agree = {
                            "type": "friend",
                            "subtype": "response",
                            "to": "$to",
                            "accept": false,
                            "version": "0.1"
                          };
                          sendMessage(json.encode(agree) + "\r\n");
                          Navigator.pop(context);
                        },
                        child: new Text("拒绝"),
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
              List<Entry> friends = new List();

              if (backInf["friends"].length > 0) {
                for (var friend in backInf["friends"]) {
                  print(friend.runtimeType);
                  friends.add(new Entry(friend["nickname"]));
                }
                list.add(Entry("我的好友", friends));
              }
              this.updateUi(1);
            } else {
              this.showMesssge(
                  backInf['info'] == null ? "登陆失败" : backInf["info"]);
            }
            break;
          case "message": //获取消息

            if(curChartTarget==backInf["from"]){

              updateChartList(backInf["body"]);

            }else{
               /**todo 更新到消息列表中去**/
            }

            break;
          case "search": //搜索好友
            if (backInf["info"] != null) {
              if (searchList.length != 0)
                searchList.removeRange(0, searchList.length);
              searchList.add(new SearchItem(backInf["info"]["id"]));
              updateSearchList();
            } else {
              showMesssge("该用户不存在，换个姿势试试！");
            }
            break;
          case "friend":       //添加好友请求和回复
            var subtype = backInf["subtype"];
            if (subtype == "request") {
              _showRequest(backInf["message"], backInf["from"]);
            } else {
              if(backInf["accept"]){
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
      this.showMesssge("连接断开");
    }
  }
  void _dynamicUpdataFriendList(String nickName){     //更新好友列表
    list = new List.from(list);
    if(list.length>0){
      list.first.list.add(new Entry(nickName));
    }else{
      List<Entry> friend =new  List();
      friend.add(new Entry(nickName));
      list.add(new Entry("我的好友",friend));
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
