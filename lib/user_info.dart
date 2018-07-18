import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_vertex_flutter/dialog.dart';

var _userNmae;

class UserInfoStateful extends StatefulWidget {
  @override
  UserInfoState createState() => UserInfoState();

  UserInfoStateful(userName) {
    _userNmae = userName;
  }
}

class UserInfoState extends State<UserInfoStateful> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView(
        children: <Widget>[
          new Container(
            child: new Padding(
              padding: new EdgeInsets.only(top: 5.00, bottom: 5.00),
              child: new Column(
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Image.asset(
                        "assets/images/user.png",
                        width: 100.0,
                        height: 100.0,
                      ),
                    ],
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        _userNmae,
                        style: new TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            color: Colors.blue,
          ),
        ],
      ),
      bottomNavigationBar: new BottomAppBar(
        child: new RaisedButton(
          onPressed: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) =>
                    new DialogStateful(_userNmae)));
          },
          child: new Text("发送消息"),
        ),
      ),
    );
  }
}
