import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_vertex_flutter/main.dart';
import 'package:social_vertex_flutter/register.dart';
import 'package:social_vertex_flutter/user.dart';
import "package:social_vertex_flutter/config/config.dart" as config;
import 'package:social_vertex_flutter/utils/requests.dart' as md5;
import 'package:social_vertex_flutter/datamodel/user_info.dart' as userInf;

class LoginStateless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "登录",
      home: new LoginStateful(),
    );
  }
}

class LoginStateful extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new LoginState();
}

class LoginState extends State<LoginStateful> {
  var _userName;
  var _password;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: new Key("login"),
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
    Socket _socket = null;
    var password = md5.generateMd5(_password);
    var userInfo = '''{
                       "type":"user",
                       "action":"login",
                       "user":"${_userName}",
                       "crypto":"${password}",
                       "version":0.1
                   }''';
    try {
      if (_socket != null) _socket.destroy();
      _socket = await Socket.connect(config.host, config.tcpPort);
      _socket.write(userInfo);
      _socket.forEach((package) {
        var backInfo = json.decode(utf8.decode(package));
        if (backInfo["login"] == false) {
          _showMesssge("Login failed");
        } else {
          userInf.id = backInfo["user"]["id"];
          userInf.socket = _socket;
          _showUser();
          return;
        }
        print(backInfo);
      });
      if (_socket != null) _socket.done;
    } catch (error) {
      _showMesssge("网络异常,请检查网络！");
    }
  }

  void _roll() {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new RegisterPage()));
  }

  void _showMesssge(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
        new SimpleDialog(
          title: new Text("消息"),
          children: <Widget>[
            new Center(
              child: new Text(message),
            )
          ],
        ));
  }

  void _showUser() {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new UserStateful()));
  }
}
