import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:social_vertex_flutter/config/constants.dart' as constants;

MyHomePageState homePageState;
String _target;

Widget showSearchDialog(MyHomePageState state) {
  homePageState = state;

  return Scaffold(
    appBar: AppBar(
      title: Text("添加"),
      centerTitle: true,
      leading: IconButton(
        icon: InputDecorator(
          decoration: InputDecoration(
            icon: Icon(Icons.arrow_back),
          ),
        ),
        onPressed: () {
          state.updateUi(2);
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
                  _target = value;
                },
              ),
              flex: 8,
            ),
            Expanded(
              child: RaisedButton(
                onPressed: _search,
                child: Text("搜索"),
              ),
              flex: 2,
            )
          ],
        ),
        backgroundColor: Colors.white70,
      ),
      body: ListView(
        children: homePageState.searchList,
      ),
    ),
  );
}

void _search() {
  if (_target != null && _target.trim() != "") {
    var message = {
      "type": "search",
      "subtype": "info",
      "id": "${homePageState.userInfo.id}",
      "password": "${homePageState.userInfo.password}",
      "keyword": "$_target",
      "version": "0.2"
    };
    var httpClient = HttpClient();
    var result;
    httpClient.put(constants.host, constants.httpPort, "search/info").then((request) {
      request.write(json.encode(message) + "\r\n");
      return request.close();
    }).then((response) {
      response.transform(utf8.decoder).listen((data) {
        result = json.decode(data);
        if (result["user"] != null) {
          homePageState.updateSearchList(result["user"]["id"]);
        } else {
          homePageState.showMessage("对不起,查无该用户！");
        }
      });
    });
  } else {
    homePageState.showMessage("搜索内容不能为空....");
  }
}

class SearchItem extends StatefulWidget {
  final String result;

  SearchItem(this.result);

  @override
  SearchItemState createState() => SearchItemState(result);
}

class SearchItemState extends State<SearchItem> {
  final String result;

  SearchItemState(this.result);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Image.asset(
                    "assets/images/person.png",
                    width: 20.0,
                    height: 20.0,
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(left: 5.00),
                      child: Text(
                        result,
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
                  "type": "friend",
                  "subtype": "request",
                  "to": "$result",
                  "message": "请添加我为你的好友，我是${homePageState.userName}",
                  "version": 0.1
                };
                Scaffold.of(context).showSnackBar(SnackBar(content: new Text("请求已经发送！")));
                homePageState.sendMessage(json.encode(message) + "\r\n");
              },
            ),
          ),
          flex: 2,
        ),
      ],
    );
  }
}
