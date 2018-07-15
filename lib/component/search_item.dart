import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var _context;

showSearchItem(String result, BuildContext context) {
  _context = context;
  return new Row(
    children: <Widget>[
      new Expanded(
        child: new Row(
          children: <Widget>[
            new Column(
              children: <Widget>[
                new Image.asset(
                  "resources/images/person.png",
                  width: 20.0,
                  height: 20.0,
                ),
              ],
            ),
            new Column(
              children: <Widget>[
                new Padding(
                    padding: new EdgeInsets.only(left: 5.00),
                    child: new Text(
                      result,
                      overflow: TextOverflow.ellipsis,
                    )),
              ],
            ),
          ],
        ),
        flex: 8,
      ),
      new Expanded(
        child: new Align(
          alignment: Alignment.centerRight,
          child: new IconButton(
            icon: new InputDecorator(
              decoration: new InputDecoration(icon: new Icon(Icons.add)),
            ),
            onPressed: _showResult,
          ),
        ),
        flex: 2,
      ),
    ],
  );
}

_showResult() {
  showDialog(
    context: _context,
    builder: (BuildContext context) {
      return new SimpleDialog(
        title: new Text("系统消息"),
        children: <Widget>[
          new Center(
            child: new Text("请求已发出"),
          )
        ],
      );
    },
  );
}
