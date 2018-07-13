import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dialog.dart';
import 'main.dart';

var mainStage;

Widget getUserCenter(MyHomePageState state) {
  mainStage = state;
  return new Scaffold(
    drawer: ListView(
      children: <Widget>[],
    ),
    appBar: new AppBar(
      title: new Text("消息"),
      centerTitle: true,
    ),
    body: new ListView(
      children: <Widget>[
        RaisedButton(
          onPressed: _showMessage,
          child: Text("Message"),
        )
      ],
    ),
    bottomNavigationBar: new BottomNavigationBar(
      items: [
        new BottomNavigationBarItem(
            icon: new Image.asset(
              "resources/images/message.png",
              width: 30.0,
              height: 30.0,
            ),
            title: new Text("消息")),
        new BottomNavigationBarItem(
            icon: new Image.asset(
              "resources/images/contacts.png",
              width: 30.0,
              height: 30.0,
            ),
            title: new Text("联系人")),
      ],
      onTap: (value) {
        if (value == 1) {
          _showContract();
        }
      },
      currentIndex: 0,
    ),
  );
}

void _showMessage() {
  //响应消息请求[
  Navigator.of(mainStage.context).push(new MaterialPageRoute(
      builder: (BuildContext context) => DialogStateless()));
}

void _showContract() {
  //响应联系人请求
  mainStage.updateUi(2);
}
