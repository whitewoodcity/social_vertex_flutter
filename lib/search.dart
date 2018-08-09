import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'config/constants.dart' as constants;

String _target;

Widget showSearchDialog(MyHomePageState state) {

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
                  _target = value;
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
        children: state.searchList,
      ),
    ),
  );
}

void _search(MyHomePageState state) {
  if (_target != null && _target.trim() != "") {
    var message = {
      constants.type: constants.search,
      constants.subtype: constants.info,
      constants.id: state.id,
      constants.password: state.password,
      constants.keyword: _target,
      constants.version: constants.currentVersion
    };
    var httpClient = HttpClient();
    var result;
    httpClient.put(constants.server, constants.httpPort, "/${constants.search}/${constants.info}").then((request) {
      request.write(json.encode(message) + constants.end);
      return request.close();
    }).then((response) {
      response.transform(utf8.decoder).listen((data) {
        result = json.decode(data);
        if (result[constants.user] != null) {
          state.updateSearchList(result[constants.user][constants.id]);
        } else {
          state.showMessage("对不起,查无该用户！");
        }
      });
    });
  } else {
    state.showMessage("搜索内容不能为空....");
  }
}

class SearchItem extends StatefulWidget {
  final String result;
  MyHomePageState state;

  SearchItem(this.result, this.state);

  @override
  SearchItemState createState() => SearchItemState(result, state);
}

class SearchItemState extends State<SearchItem> {
  final String result;
  MyHomePageState state;

  SearchItemState(this.result, this.state);

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
                  constants.type: constants.friend,
                  constants.subtype: constants.request,
                  constants.to: result,
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
