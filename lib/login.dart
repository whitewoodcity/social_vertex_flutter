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
  return Scaffold(
    key: Key("login"),
    appBar: AppBar(
      title: Text("登录"),
    ),
    body: Center(
      child: ListView(
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
          Form(
            child: Column(
              children: <Widget>[
                TextField(
                  textAlign: TextAlign.start,
                  onChanged: setUserName,
                  decoration: InputDecoration(labelText: "用户名:"),
                ),
                TextField(
                  textAlign: TextAlign.start,
                  onChanged: setUserPassword,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "密码"),
                ),
                SizedBox.fromSize(
                  size: Size(0.00, 10.0),
                ),
                RaisedButton(
                  onPressed: () {
                    if (_password != "" && _userName != "") {
                      _login();
                    } else {
                      homeState.showMessage("用户名/密码不能为空！");
                    }
                  },
                  child: Text("登录"),
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
    "type": "user",
    "subtype": "login",
    "id": "$_userName",
    "password": "$password"
  };
  await homeState.initConnect();
  homeState.sendMessage(json.encode(userInfo) + "\r\n");
}

void _roll() {
  Navigator.of(homeState.context).push(MaterialPageRoute(
      builder: (BuildContext context) => RegisterPage()));
}
