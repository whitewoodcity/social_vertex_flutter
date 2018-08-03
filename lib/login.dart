import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'register.dart';
import 'package:social_vertex_flutter/utils/requests.dart' as md5;

var _userName = "";
var _password = "";
MyHomePageState homeState;

Widget showLogin(MyHomePageState state) {
  homeState = state;
  return new Scaffold(
    key: new Key("login"),
    appBar: new AppBar(
      title: new Text("登录"),
    ),
    body: new Center(
      child: new ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              child: Image.asset(
                "assets/images/loginIcon.png",
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
                  onPressed: () {
                    if (_password != "" && _userName != "") {
                      _login();
                    } else {
                      homeState.showMesssge("用户名/密码不能为空！");
                    }
                  },
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
  var password = md5.generateMd5(_password);
  var userInfo = {
                       "type":"user",
                       "subtype":"login",
                       "id":"$_userName",
                       "password":"$password"
                   };
  await homeState.initConnect();
   homeState.sendMessage(json.encode(userInfo)+"\r\n");
}

void _roll() {
  Navigator.of(homeState.context).push(new MaterialPageRoute(
      builder: (BuildContext context) => new RegisterPage()));
}
