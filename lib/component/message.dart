import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showMessage(String name, String message) {
  return new GestureDetector(
    child: new Column(
      children: <Widget>[
        new Row(
          children: <Widget>[
            new Expanded(
                flex: 1,
                child: new Image.asset(
                  "resources/images/message.png",
                  width: 30.0,
                  height: 30.0,
                )),
            new Expanded(
              flex: 9,
              child: new Padding(
                padding: new EdgeInsets.only(left: 5.00),
                child: new Text(
                  name,
                  style: new TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ],
        ),
        new Divider(
          color: Colors.black12,
        )
      ],
    ),
    onTap: () {
      _showDialog(name);
    },
  );
}

void _showDialog(String name) {
  print(name);
}
