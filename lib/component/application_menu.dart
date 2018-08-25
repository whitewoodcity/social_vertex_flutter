import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';

showAppMenu(MyHomePageState state) {
  return Scaffold(
    body: ListView(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Container(
                width: 100.0,
                height: 100.0,
                child: Image.asset("assets/images/flutter.png"),
              ),
            ],
          ),
          color: Colors.blue,
          height: 100.0,
        ),
        Text(
          state.nickname,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: "微软雅黑",
          ),
        ),
      ],
    ),
    bottomNavigationBar: BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.cloud_upload), title: Text("更新")),
        BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app), title: Text("退出"))
      ],
      onTap: (value) {
        print(value);
        if(value == 1){
          state.dispose();
        }
      },
      currentIndex: 1,
    ),
  );
}
