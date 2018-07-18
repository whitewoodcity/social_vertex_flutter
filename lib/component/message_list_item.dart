import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageListItem extends StatelessWidget {
  String _message;

  MessageListItem(this._message);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new IconButton(
              icon: new InputDecorator(
                  decoration:
                      new InputDecoration(icon: new Icon(Icons.message))),
              onPressed: () {},
            ),
            flex: 1,
          ),
          new Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: new Text(_message),
            ),
            flex: 9,
          ),
        ],
      ),
      onTap: () {
        print(_message);
      },
    );
  }
}
