import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_vertex_flutter/login.dart';
import 'utils/newuser_info.dart';

class RegisterPage extends StatefulWidget {
  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<RegisterPage> {
  String _userName = "";
  String _password = "";
  String _repassword = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("用户注册"),
        centerTitle: true,
      ),
      body: new ListView(
        children: <Widget>[
          new TextField(
            textAlign: TextAlign.start,
            onChanged: (value) {
              _userName = value;
            },
            decoration: InputDecoration(labelText: "用户名"),
          ),
          new TextField(
            textAlign: TextAlign.start,
            obscureText: true,
            onChanged: (String value) {
              _password = value;
            },
            decoration: InputDecoration(labelText: "密码"),
          ),
          new TextField(
            obscureText: true,
            onChanged: (String value) {
              _repassword = value;
            },
            decoration: InputDecoration(labelText: "确认密码"),
          ),
          new SizedBox.fromSize(
            size: Size(0.0, 10.0),
          ),
          Center(
            child: RaisedButton(
              onPressed: () {
                if (_userName != "" && _password != "" && _repassword != "") {
                  if (_password == _repassword) {
                    _register(NewUser(_userName, _password));
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

  void _register(NewUser user) async {
    var userInfo = json.encode(user);
    HttpClient client = new HttpClient();
    try {
      client
          .open("POST", "192.168.1.110", 8080, "/register")
          .then((HttpClientRequest req) {
        req.write(userInfo);
        return req.close();
      }).then((HttpClientResponse response) {
        response.transform(utf8.decoder).listen((contents) {
          print(contents);
        });
      });
    } finally {
      if (client != null) client.close();
    }
  }

  void _registerAlert(String info) {
    Navigator.push(
        context,
        MaterialPageRoute(
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
                    )
                  ],
                ),
            settings: RouteSettings(name: "aysc", isInitialRoute: true)));
  }
}
