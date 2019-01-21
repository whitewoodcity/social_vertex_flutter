import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'register.dart';
import 'utils/util.dart';
import 'config/constants.dart' as constants;

TextEditingController id = TextEditingController();
TextEditingController pw = TextEditingController();

Widget showLogin(MyHomePageState state) {
  _clearUserData(state);
  return Scaffold(
    key: Key(constants.login),
    appBar: AppBar(
      title: Text("登录"),
    ),
    body: Center(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 50.0, left: 20.0, right: 20.0, bottom: 20.0),
            child: Align(
              child: LayoutBuilder(builder: (context, constraint) {
                return Image.asset(
                  "assets/images/flutter.png",
                  width: constraint.biggest.width / 2,
                  height: constraint.biggest.width / 2,
                );
              }),
              alignment: Alignment.center,
            ),
          ),
          Form(
            child: Column(
              children: <Widget>[
                TextFormField(
                  textAlign: TextAlign.start,
//                  onChanged: (value) => (state.id = value),
                  controller: id,
                  decoration: InputDecoration(labelText: "用户名："),
                ),
                TextFormField(
                  textAlign: TextAlign.start,
//                  onChanged: (value) => (state.password = value),
                  controller: pw,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "密码："),
                ),
                SizedBox.fromSize(
                  size: Size(0.00, 10.0),
                ),
                RaisedButton(
                  onPressed: () {
                    if (id.text.trim() != "" && pw.text.trim() != "") {
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
    constants.type: constants.user,
    constants.subtype: constants.login,
    constants.id: id.text.trim(),//state.id,
    constants.password: md5(pw.text.trim())//md5(state.password)
  };
  await state.initConnect();
  print(userInfo);
  state.sendMessage(json.encode(userInfo));
}

void _roll(MyHomePageState state) {
  Navigator.push(state.context, MaterialPageRoute(builder: (BuildContext context) => RegisterPage()))
    .then((value){
      if(value is Map){
        Map map = value as Map<String, String>;
        if(map.containsKey(constants.id))
          id.text = map[constants.id];
        if(map.containsKey(constants.password))
          pw.text = map[constants.password];
        state.updateCurrentUI();
      }
  });
}

void _clearUserData(MyHomePageState state) {
  state.friends.clear();
}
