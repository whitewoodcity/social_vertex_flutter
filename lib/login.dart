import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'register.dart';
import 'utils/util.dart';
import 'config/constants.dart';

Widget showLogin(MyHomePageState state) {
  _clearUserData(state);
  return Scaffold(
    key: Key(login),
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
                  onChanged: (value) => (state.id = value),
                  decoration: InputDecoration(labelText: "用户名："),
                ),
                TextField(
                  textAlign: TextAlign.start,
                  onChanged: (value) => (state.password = value),
                  obscureText: true,
                  decoration: InputDecoration(labelText: "密码："),
                ),
                SizedBox.fromSize(
                  size: Size(0.00, 10.0),
                ),
                RaisedButton(
                  onPressed: () {
                    if (state.id != "" && state.password != "") {
                      _login(state);
                    } else {
                      state.showMessage("用户名/密码不能为空！");
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
      onPressed: () => (_roll(state)),
      child: Text("注册"),
    ),
  );
}

void _login(MyHomePageState state) async {
  var userInfo = {
    type: user,
    subtype: login,
    id: state.id,
    password: md5(state.password)
  };
  await state.initConnect();
  state.sendMessage(json.encode(userInfo));
}

void _roll(MyHomePageState state) {
  Navigator.of(state.context).push(MaterialPageRoute(
      builder: (BuildContext context) => RegisterPage()));
}
void _clearUserData(MyHomePageState state){
  state.friends.clear();
}
