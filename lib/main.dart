import 'package:flutter/material.dart';
import 'register.dart';
import 'contacts.dart';
import 'login.dart';
import 'user.dart';
import 'utils/keys.dart' as keys;

void main() => runApp(MyApplication()); //整个应用的入口

class MyApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "social-vertex-flutter", home: new MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  var stage = 0;
  @override
  Widget build(BuildContext context) {
    switch (stage) {
      case keys.user:
        return getUserCenter(this); //用户中心界面
      case keys.contacts:
        return getContactsList(this); //联系人界面
      default:
        return login(this); //登录界面
    }
  }

  void updateUi(int state) {
    //通知Flutter框架更新子Widget状态
    setState(() {
      stage = state;
    });
  }
}
