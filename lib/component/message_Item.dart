import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageEntry extends StatelessWidget {
  String _message;

  MessageEntry(this._message);

  Widget _buildEntry(String entry) {
    return new Container(
      child: new Row(
        children: <Widget>[
          new Column(
            children: <Widget>[
              new IconButton(
                  icon: new InputDecorator(
                    decoration:
                        InputDecoration(icon: new Icon(Icons.person_outline)),
                  ),
                  onPressed: null)
            ],
          ),
          new ClipRRect(
            child: new Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child:_message==null?null:new Text(_message),
              ),
              color: Colors.grey,
              width: 200.0,
              margin: new EdgeInsets.only(left: 2.00),
            ),
            borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildEntry(_message);
  }
}
