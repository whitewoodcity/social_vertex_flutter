import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageListItem extends StatelessWidget {
  String _message;

  MessageListItem(this._message);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        children: <Widget>[
          Expanded(
            child: IconButton(
              icon: InputDecorator(
                  decoration:
                      InputDecoration(icon: Icon(Icons.message))),
              onPressed: () {},
            ),
            flex: 1,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(_message),
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
