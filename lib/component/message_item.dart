import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageEntry extends StatelessWidget {
  String _message;
  BuildContext _context;

  MessageEntry(this._message);

  Widget _buildEntry(String entry) {
    return GestureDetector(
      child: Container(
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                IconButton(
                    icon: InputDecorator(
                      decoration:
                          InputDecoration(icon: Icon(Icons.person_outline)),
                    ),
                    onPressed: null)
              ],
            ),
            ClipRRect(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: _message == null
                      ? null
                      : Text(
                          _message,
                          style: TextStyle(fontSize: 18.0),
                        ),
                ),
                color: Colors.grey,
                width: 200.0,
                margin: EdgeInsets.only(left: 2.00),
              ),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            )
          ],
        ),
      ),
      onTap: () {
        showDialog(
          context: _context,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: <Widget>[
                Center(
                  child: Text(
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
    return _buildEntry(_message);
  }
}
