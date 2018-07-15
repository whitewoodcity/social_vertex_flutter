import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'register.dart';
import 'main.dart';
import 'utils/keys.dart' as keys;

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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                child: Image.asset(
                  "resources/images/loginIcon.png",
                  width: 100.00,
                  height: 100.00,
                ),
                alignment: Alignment.center,
              ),
            ),
            new Form(
              child: new Column(
                children: <Widget>[
                  new TextField(
                    textAlign: TextAlign.start,
                    onChanged: setUserName,
                    decoration: InputDecoration(labelText: "用户名:"),
                  ),
                  new TextField(
                    textAlign: TextAlign.start,
                    onChanged: setUserPassword,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "密码"),
                  ),
                  new SizedBox.fromSize(
                    size: Size(0.00, 10.0),
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
  mainState.updateUi(1);
  var userInfo = '{"${_userName}":"${_password}"}';
  Socket _socket;
  try {
    if (_socket != null) _socket.destroy();
    _socket = await Socket.connect("192.168.1.110", 6666);
    _socket.write(userInfo);
    _socket.forEach((package) {
      print("Test");
      var backInfo = json.decode(utf8.decode(package));
      print(package);
    });
    if (_socket != null) _socket.done;
  } catch (error) {
    print(_socket == null ? error : "连接断开");
  }
}

void _roll() {
  Navigator.of(mainState.context).push(
      new MaterialPageRoute(builder: (BuildContext context) => Register()));
}
