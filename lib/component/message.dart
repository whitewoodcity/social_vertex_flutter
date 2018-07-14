import 'package:flutter/cupertino.dart';

showMessage(String name, String message) {
  return new Row(
    children: <Widget>[
      new Column(
        children: <Widget>[
          new Image.asset(
            "resources/images/message.png",
            width: 35.0,
            height: 35.0,
          ),
        ],
        textBaseline: TextBaseline.alphabetic,
      ),
      new Column(
        children: <Widget>[
          new Text(
            name,
            style: new TextStyle(fontSize: 25.0),
          ),
          new Text(
            message,
            style: new TextStyle(
              fontSize: 15.0,
            ),
          )
        ],
      )
    ],
  );
}
