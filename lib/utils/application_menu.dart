import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showAppMenu() {
  int curIndex=0;
  return new Scaffold(
    appBar: new AppBar(
      title: new Text("flutter应用"),
    ),
    body: new ListView(),
    bottomNavigationBar: new BottomNavigationBar(items: [
      new BottomNavigationBarItem(
          icon: new Image.asset(
            "resources/images/setting.png",
            width: 20.0,
            height: 20.0,
          ),
          title: new Text("设置")),
      new BottomNavigationBarItem(
          icon: new Image.asset(
            "resources/images/dark.png",
            width: 20.0,
            height: 20.0,
          ),
          title: new Text("夜间"))
    ],
    onTap: (value){
      print(value);
      curIndex=value;
    },
    currentIndex:curIndex),
  );
}
