import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';

MyHomePageState homePageState;
String _target;

Widget showSearchDialog(MyHomePageState state, List<SearchItem> list) {
  homePageState = state;

  return new Scaffold(
    appBar: new AppBar(
      title: new Text("添加"),
      centerTitle: true,
      leading: new IconButton(
        icon: new InputDecorator(
          decoration: new InputDecoration(
            icon: new Icon(Icons.arrow_back),
          ),
        ),
        onPressed: () {
          state.updateUi(2);
        },
      ),
    ),
    body: new Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                onChanged: (value) {
                  _target = value;
                },
              ),
              flex: 8,
            ),
            new Expanded(
              child: new RaisedButton(
                onPressed: _search,
                child: new Text("搜索"),
              ),
              flex: 2,
            )
          ],
        ),
        backgroundColor: Colors.white70,
      ),
      body: new ListView(
        children: list,
      ),
    ),
  );
}

void _search() {
  if (_target != null && _target.trim() != "") {
    var message = {
      "type": "search",
      "subtype": "info",
      "keyword": "$_target",
      "version": "0.1"
    };
    homePageState.sendMessage(json.encode(message) + "\r\n");
  } else {
    homePageState.showMesssge("搜索内容不能为空....");
  }
}

class SearchItem extends StatefulWidget {
  final String result;

  SearchItem(this.result);

  @override
  SearchItemState createState() => new SearchItemState(result);
}

class SearchItemState extends State<SearchItem> {
  final String result;

  SearchItemState(this.result);

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new Row(
            children: <Widget>[
              new Column(
                children: <Widget>[
                  new Image.asset(
                    "assets/images/person.png",
                    width: 20.0,
                    height: 20.0,
                  ),
                ],
              ),
              new Column(
                children: <Widget>[
                  new Padding(
                      padding: new EdgeInsets.only(left: 5.00),
                      child: new Text(
                        result,
                        overflow: TextOverflow.ellipsis,
                      )),
                ],
              ),
            ],
          ),
          flex: 8,
        ),
        new Expanded(
          child: new Align(
            alignment: Alignment.centerRight,
            child: new IconButton(
              icon: new InputDecorator(
                decoration: new InputDecoration(icon: new Icon(Icons.add)),
              ),
              onPressed: () {
                var message = {
                  "type": "friend",
                  "subtype": "request",
                  "to": "$result",
                  "message": "请添加我为你的好友，我是${homePageState.userName}",
                  "version": 0.1
                };
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
