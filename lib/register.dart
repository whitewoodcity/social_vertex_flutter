import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var userName = "";
var password = "";
var repassword = "";
var information = "";

StatelessWidget showRegisterDialog(BuildContext context) {
  return new AlertDialog(
    title: new Text("用户注册"),
    content: new ListView(
      children: <Widget>[
        new Text("用户名:"),
        new TextField(
          textAlign: TextAlign.start,
          onChanged: (String value) {
            print(value);
            userName = value;
          },
        ),
        new Text("密码:"),
        new TextField(
          textAlign: TextAlign.start,
          obscureText: true,
          onChanged: (String value) {
            print(value);
            password = value;
          },
        ),
        new Text("确认密码:"),
        new TextField(
          obscureText: true,
          onChanged: (String value) {
            repassword = value;
          },
        ),
        new SizedBox.fromSize(
          size: Size(0.0, 10.0),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                onPressed: () {
                  print("hello");
                  if (!(userName == "") &&
                      !(password == "") &&
                      !(repassword == "")) {
                    if (password == repassword) {
                      _register();
                    } else {
                      information = "两次密码不匹配";
                    }
                  } else {
                    information = "输入输入信息不能为空";
                  }
                },
                child: Text("注册"),
              ),
            ),
            Expanded(
              child: RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("取消"),
              ),
            )
          ],
        ),
        new Row(
          children: <Widget>[
            new Expanded(
                child: new FlatButton(
                    onPressed: null, child: new Text(information))),
          ],
        )
      ],
    ),
  );
}

void _register() {
  //响应用户注册请求
}
