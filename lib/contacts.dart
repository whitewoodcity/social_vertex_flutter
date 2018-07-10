import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';

var mainState;

Widget getContactsList(MyHomePageState myHomePageState) {
  mainState = myHomePageState;
  return new Scaffold(
      appBar: new AppBar(
        title: Row(
          children: <Widget>[
            Expanded(
              child: new Center(
                child: new Text("User"),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          RaisedButton(
            onPressed: selectContacts,
            child: Text("联系人"),
          )
        ],
      ),
      bottomNavigationBar: new BottomAppBar(
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new RaisedButton(
                onPressed: _showMessage,
                child: new Text("消息"),
              ),
            ),
            new Expanded(
                child: new RaisedButton(
              onPressed: _showContract,
              child: new Text("联系人"),
            )),
          ],
        ),
      ));
}

void _showMessage() {
  //响应消息请求
  mainState.updateUi(1);
}

void _showContract() {
  //相应联系人请求
}

void selectContacts() {}
