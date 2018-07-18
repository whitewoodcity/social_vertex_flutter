import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_vertex_flutter/datamodel/user_info.dart' as userInfo;

showAppMenu() {
  int curIndex = 0;
  return new Scaffold(
    body: new ListView(
      children: <Widget>[
        new Container(
          child: new Column(
            children: <Widget>[
              new ClipRRect(
                child: new Container(
                  width: 100.0,
                  height: 100.0,
                  child: new Image.asset("assets/images/user.png"),
                ),
                borderRadius: new BorderRadius.all(new Radius.circular(90.0)),
              ),
              new Text(
                userInfo.id,
                style: new TextStyle(
                  fontSize: 20.0,
                  fontFamily: "微软雅黑",
                ),
              ),
            ],
          ),
          color: Colors.lightBlue,
          height: 150.0,
        )
      ],
    ),
    bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
              icon: new Image.asset(
                "assets/images/setting.png",
                width: 20.0,
                height: 20.0,
              ),
              title: new Text("设置")),
          new BottomNavigationBarItem(
              icon: new Image.asset(
                "assets/images/dark.png",
                width: 20.0,
                height: 20.0,
              ),
              title: new Text("夜间"))
        ],
        onTap: (value) {
          print(value);
          curIndex = value;
        },
        currentIndex: curIndex),
  );
}
