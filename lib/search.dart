import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'utils/util.dart';
import 'main.dart';
import 'config/constants.dart' as constants;

String _keyword="";
var _result = {};

Widget showSearchDialog(MyHomePageState state) {
  List<Widget> itemList = [];

  if (_result.containsKey(constants.user) &&_result[constants.user]!=null) {
    var userItem = UserItem(state);
    itemList.add(userItem);
  }

  var searchRow = Row(
    children: <Widget>[
      Expanded(
        child: TextField(
          onChanged: (value) {
            _keyword = value;
          },
          controller: TextEditingController(
            text: _keyword,
          ),
        ),
        flex: 8,
      ),
      Expanded(
        child: RaisedButton(
          onPressed: () {
            _search(state);
          },
          child: Text("搜索"),
        ),
        flex: 2,
      )
    ],
  );

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
          _result = {};
          state.updateUI(constants.userPage);
        },
      ),
    ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(child: ListView(children: itemList)), //itemList
        Container(
            color: Colors.white,
            padding: EdgeInsets.all(10.0),
            child: searchRow),
      ],
    ),
  );
}

void _search(MyHomePageState state) {
  if (_keyword != null && _keyword.trim() != "") {
    var message = {
      constants.type: constants.search,
      constants.subtype: constants.info,
      constants.id: state.id,
      constants.password: md5(state.password),
      constants.keyword: _keyword,
      constants.version: constants.currentVersion
    };
    put("${constants.protocol}${constants.server}/${constants.search}/${constants.info}",
        body: json.encode(message) + constants.end)
        .then((response) {
      if (response.statusCode == 200) {
        try{
          _result = json.decode(utf8.decode(response.bodyBytes));
          state.updateCurrentUI();
          if(!_result.containsKey(constants.user)||_result[constants.user]==null) state.showMessage("查无此人");
        }catch(e){
          state.showMessage(e.toString());
        }
      }
    });
    _keyword = "";
  } else {
    state.showMessage("搜索内容不能为空....");
  }
}

class UserItem extends StatefulWidget {
  MyHomePageState state;

  UserItem(this.state);

  @override
  UserItemState createState() => UserItemState(state);
}

class UserItemState extends State<UserItem> {
  MyHomePageState state;

  UserItemState(this.state);

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
                        _result[constants.user][constants.id],
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
                  constants.to: _result[constants.user][constants.id],
                  constants.message: "请添加我为你的好友，我是${state.nickname}",
                  constants.version: constants.currentVersion
                };
                Scaffold
                    .of(context)
                    .showSnackBar(SnackBar(content: Text("请求已经发送！")));
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
