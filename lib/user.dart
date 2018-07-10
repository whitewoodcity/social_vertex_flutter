import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';

var mainStage;

Widget getUserCenter(MyHomePageState state) {
  mainStage=state;
  return new Scaffold(
      appBar: new AppBar(
        title: Row(
          children: <Widget>[
            Expanded(
              child: new Center(
                child: new Text("User"),
              ),
            ),
          ],
        ),
      ),
      body: new Stack(
        children: <Widget>[
          new ListView(
            children: <Widget>[
              RaisedButton(
                onPressed: _showMessage,
                child: Text("Message"),
              )
            ],
          )
        ],
      ),
      bottomNavigationBar: new BottomAppBar(
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new RaisedButton(
                onPressed: _showMessage,
                child: new Text("消息"),
              ),
            ),
            new Expanded(
                child: new RaisedButton(
              onPressed: _showContract,
              child: new Text("联系人"),
            )),
          ],
        ),
      ));
}
void _showMessage() { //响应消息请求[

}
void _showContract() {  //相应联系人请求
 mainStage.updateUi(2);
}
