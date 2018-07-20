import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'component/search_item.dart';
import 'component/search_item.dart';
import 'main.dart';

MyHomePageState homePageState;

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
              child: new TextField(),
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

void _search() {}
