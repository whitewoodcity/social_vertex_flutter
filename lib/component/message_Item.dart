import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageEntry extends StatelessWidget {
  String _message;
  String _source;
  BuildContext _context;

  MessageEntry(this._message, this._source);

  Widget _buildEntry(String entry, String source) {
    return new GestureDetector(
      child: new Container(
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
                  child: _message == null
                      ? null
                      : new Text(
                          _message,
                          style: new TextStyle(fontSize: 18.0),
                        ),
                ),
                color: Colors.grey,
                width: 200.0,
                margin: new EdgeInsets.only(left: 2.00),
              ),
              borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
            )
          ],
        ),
      ),
      onTap: () {
        showDialog(
          context: _context,
          builder: (BuildContext context) {
            return new SimpleDialog(
              children: <Widget>[
                new Center(
                  child: new Text(
                    _message,
                    style: TextStyle(
                        fontSize: 22.0,
                        fontFamily: "微软雅黑",
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return _buildEntry(_message, this._source);
  }
}
