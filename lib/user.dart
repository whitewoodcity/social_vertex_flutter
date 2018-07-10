import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


Widget getUserCenter() {

  return new Scaffold(
    appBar: new AppBar(
      title: new Text("User"),
    ),
    bottomNavigationBar: new BottomAppBar(
      child: new Row(
        children: <Widget>[
          new Expanded(child: new RaisedButton(onPressed: null,child: new Text("消息"),),),
          new Expanded(child: new RaisedButton(onPressed: null,child: new Text("联系人"),)),
          new Expanded(child: new RaisedButton(onPressed: null,child: new Text("动态"),))
        ],
      ),
    )
  );

}