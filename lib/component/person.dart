import 'package:flutter/cupertino.dart';

getPerson(String name) {
  return new Row(
    children: <Widget>[
      new Column(
        children: <Widget>[
          new Image.asset(
            "resources/images/person.png",
            width: 20.0,
            height: 20.0,
          )
        ],
      ),
      new Column(
        children: <Widget>[
          new Text(name)
        ],
      )
    ],
  );
}
