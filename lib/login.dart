import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'main.dart';
import 'package:social_vertex_flutter/utils/keys.dart' as keys;

var _userName;
var _password;
var mainState;

Widget login(MyHomePageState state) {
  mainState = state;
  return new Scaffold(
      appBar: new AppBar(
        title: new Text("登录"),
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[
            new Image.asset("resources/images/loginIcon.png"),
            new Form(
              child: new Column(
                children: <Widget>[
                  new TextField(
                    textAlign: TextAlign.start,
                    onChanged: setUserName,
                    decoration:InputDecoration(
                      labelText: "用户名:"
                    ),
                  ),
                  new TextField(
                    textAlign: TextAlign.start,
                    onChanged: setUserPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "密码:",
                    ),
                  ),
                  new RaisedButton(
                    onPressed: _login,
                    child: new Text("登录"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _roll,
        child: Text("注册"),
      ));
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

void _roll() {
  mainState.showRegister();
}
