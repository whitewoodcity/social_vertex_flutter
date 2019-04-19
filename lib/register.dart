import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import "config/constants.dart" as constants;
import 'utils/util.dart' as util;

class RegisterPage extends StatefulWidget {
  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<RegisterPage> {

  String _userName="";
  String _password="";
  String _repassword="";
  String _nickname="";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("用户注册"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          TextField(
            textAlign: TextAlign.start,
            onChanged: (value) {
              _userName = value;
            },
            decoration: InputDecoration(labelText: "用户名"),
          ),
          TextField(
            textAlign: TextAlign.start,
            obscureText: true,
            onChanged: (String value) {
              _password = value;
            },
            decoration: InputDecoration(labelText: "密码"),
          ),
          TextField(
            obscureText: true,
            onChanged: (String value) {
              _repassword = value;
            },
            decoration: InputDecoration(labelText: "确认密码"),
          ),
          TextField(
            onChanged: (String value) {
              _nickname = value;
            },
            decoration: InputDecoration(labelText: "昵称"),
          ),
          SizedBox.fromSize(
            size: Size(0.0, 10.0),
          ),
          Center(
            child: RaisedButton(
              onPressed: () {
                if (_userName != "" && _password != "" && _repassword != "") {
                  if (_password == _repassword) {
                    _register(context);
                  } else {
                    _registerAlert("两次密码不匹配");
                  }
                } else {
                  _registerAlert("信息不完整");
                }
              },
              child: Text("注册"),
            ),
          ),
        ],
      ),
    );
  }

  void _register(BuildContext context) async {
    var info = {
      constants.type: constants.user,
      constants.subtype: constants.register,
      constants.id: "$_userName",
      constants.password: "${util.md5(_password)}",
      constants.password2: "${util.md5(_repassword)}",
      constants.nickname: "$_nickname",
      constants.version: constants.currentVersion
    };

    put("${constants.protocol}${constants.server}/",
            headers: {"Content-Type":"application/json"},
            body: json.encode(info) + constants.end)
        .then((response) {
      if (response.statusCode == 200) {
        var result = json.decode(utf8.decode(response.bodyBytes));
        if (result[constants.register]) {
          Navigator.popAndPushNamed(context, "/login",
            result:{constants.id:_userName, constants.password: _password},
            arguments: {constants.id:_userName, constants.password: util.md5(_password), constants.nickname: _nickname});
        } else {
          _registerAlert(result["info"]);
        }
      } else {
        _registerAlert("服务器异常,请重试!");
      }
    }).catchError((error)=> print(error));
  }

  void _registerAlert(String info) {
    showDialog(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
            title: Text("消息"),
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(info),
              ),
              SizedBox.fromSize(
                size: Size(0.00, 10.00),
              ),
              Align(
                alignment: Alignment.center,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("确定"),
                ),
              ),
            ],
          ),
    );
  }
}
