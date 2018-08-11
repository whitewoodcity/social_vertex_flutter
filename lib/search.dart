import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'config/constants.dart' as constants;

String _keyword;
var _result = {};

Widget showSearchDialog(MyHomePageState state) {

  List<Widget> itemList = [];
  
  if(_result.containsKey(constants.user)){
    var userItem = UserItem(_result[constants.user][constants.id],state);
    itemList.add(userItem);
  }

  return Scaffold(
    appBar: AppBar(
      title: Text("搜索"),
      centerTitle: true,
      leading: IconButton(
        icon: InputDecorator(
          decoration: InputDecoration(
            icon: Icon(Icons.arrow_back),
          ),
        ),
        onPressed: () {
          _keyword = "";
          _result = {};
          state.updateUI(constants.userPage);
        },
      ),
    ),
    body: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                onChanged: (value) {
                  _keyword = value;
                },
              ),
              flex: 8,
            ),
            Expanded(
              child: RaisedButton(
                onPressed: (){_search(state);},
                child: Text("搜索"),
              ),
              flex: 2,
            )
          ],
        ),
        backgroundColor: Colors.white70,
      ),
      body: ListView(
        children: itemList,
      ),
    ),
  );
}

void _search(MyHomePageState state) {
  if (_keyword != null && _keyword.trim() != "") {
    var message = {
      constants.type: constants.search,
      constants.subtype: constants.info,
      constants.id: state.id,
      constants.password: state.password,
      constants.keyword: _keyword,
      constants.version: constants.currentVersion
    };
    var httpClient = HttpClient();
    httpClient.put(constants.server, constants.httpPort, "/${constants.search}/${constants.info}").then((request) {
      request.write(json.encode(message) + constants.end);
      return request.close();
    }).then((response) {
      response.transform(utf8.decoder).listen((data) {
        try {
          _result = json.decode(data);
          state.updateCurrentUI();
        }catch(e){
          state.showMessage(e);
        }
      });
    });
    _keyword = "";
  } else {
    state.showMessage("搜索内容不能为空....");
  }
}

class UserItem extends StatefulWidget {
  final String userId;
  MyHomePageState state;

  UserItem(this.userId, this.state);

  @override
  UserItemState createState() => UserItemState(userId, state);
}

class UserItemState extends State<UserItem> {
  final String userId;
  MyHomePageState state;

  UserItemState(this.userId, this.state);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Icon(Icons.account_box),
                ],
              ),
              Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left: 5.00),
                      child: Text(
                        userId,
                        overflow: TextOverflow.ellipsis,
                      )),
                ],
              ),
            ],
          ),
          flex: 8,
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: InputDecorator(
                decoration: InputDecoration(icon: Icon(Icons.add)),
              ),
              onPressed: () {
                var message = {
                  constants.type: constants.friend,
                  constants.subtype: constants.request,
                  constants.to: userId,
                  constants.message: "请添加我为你的好友，我是${state.nickname}",
                  constants.version: constants.currentVersion
                };
                Scaffold.of(context).showSnackBar(SnackBar(content: Text("请求已经发送！")));
                state.sendMessage(json.encode(message));
              },
            ),
          ),
          flex: 2,
        ),
      ],
    );
  }
}
