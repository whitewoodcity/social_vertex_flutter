import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showAppMenu(String userName) {
  int curIndex = 0;
  return Scaffold(
    body: ListView(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              ClipRRect(
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  child: Image.asset("assets/images/user.png"),
                ),
                borderRadius: BorderRadius.all(Radius.circular(90.0)),
              ),
              Text(
                userName,
                style: TextStyle(
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
    bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Image.asset(
                "assets/images/setting.png",
                width: 20.0,
                height: 20.0,
              ),
              title: Text("设置")),
          BottomNavigationBarItem(
              icon: Image.asset(
                "assets/images/dark.png",
                width: 20.0,
                height: 20.0,
              ),
              title: Text("夜间"))
        ],
        onTap: (value) {
          print(value);
          curIndex = value;
        },
        currentIndex: curIndex),
  );
}
