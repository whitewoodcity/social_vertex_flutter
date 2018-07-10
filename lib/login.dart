import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:social_vertex_flutter/utils/keys.dart' as keys;

var _userName;
var _password;
var mainState;

Widget login(MyHomePageState state) {
  mainState = state;
  return new Scaffold(
    appBar: new AppBar(
      title: new Text("social-vertex-flutter"),
    ),
    body: new Container(
      //margin: EdgeInsets.symmetric(100.0),
      margin: EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Expanded(
                child: new Text("用户名:"),
              ),
              new Expanded(
                flex: 5,
                child: new TextField(
                  key: new Key("userName"),
                  onChanged: setUserName,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          new Row(
            children: <Widget>[
              new Expanded(
                key: new Key(""),
                child: new Text("密码:"),
              ),
              new Expanded(
                flex: 5,
                child: new TextField(
                  key: new Key("password"),
                  textAlign: TextAlign.start,
                  onChanged: setUserPassword,
                  obscureText: true,
                ),
              )
            ],
          ),
          new Row(
            children: <Widget>[
              new Expanded(
                  child: new RaisedButton(
                child: new Text(
                  "登录",
                  style: TextStyle(fontSize: 20.0, fontFamily: '隶书'),
                ),
                onPressed: _login,
              )),
              new Expanded(
                  child: new RaisedButton(
                onPressed: _roll,
                child: new Text("注册",
                    style: TextStyle(fontSize: 20.0, fontFamily: '隶书')),
              ))
            ],
          )
        ],
      ),
    ),
  );
}

void setUserName(String value) {
  _userName = value;
}

void setUserPassword(String value) {
  _password = value;
}

void _login() async {
  var userInfo = '{"${_userName}":"${_password}"}';
  mainState.updateUi(1);
  Socket _socket;
  if (_socket != null) _socket.destroy();
  _socket = await Socket.connect("119.23.22.230", 8081);
  _socket.write(userInfo);
  _socket.forEach((package) {
    var backInfo = json.decode(utf8.decode(package));
    /*
    验证返回信息
     */
  });
  try {
    _socket.done;
  } catch (throwable) {
    print(throwable);
  }
}

void _roll() {}
