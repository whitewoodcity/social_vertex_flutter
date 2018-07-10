import 'package:flutter/material.dart';
import 'login.dart';
import 'user.dart';
import 'utils/keys.dart' as keys;

void main() => runApp(MyApplication()); //整个应用的入口

class MyApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(title: "social-vertex-flutter", home: new MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  var stage = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    switch(stage){
      case keys.login:
        return getWidget(this);
      default:
        return getUserCenter();
    }
  }
  void updateUi(int state){
    print(state);
    setState(() {
      stage = state;
    });
  }
}
