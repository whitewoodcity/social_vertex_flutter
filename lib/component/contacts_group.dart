import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

getGroup(String title) {
  return new Row(
    children: <Widget>[
      new Column(
        children: <Widget>[
          new Image.asset(
            "resources/images/group.png",
            width: 30.0,
            height: 30.0,
          ),
        ],
      ),
      new Column(
        children: <Widget>[
          new Text(title),
        ],
      ),
    ],
  );
}
