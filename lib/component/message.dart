import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  var _name;
  var _context;

  Message(this._name);

  Widget _build() {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Image.asset(
                  "assets/images/message.png",
                  width: 30.0,
                  height: 30.0,
                ),
              ),
              Expanded(
                flex: 9,
                child: Padding(
                  padding: EdgeInsets.only(left: 5.00),
                  child: Text(
                    _name,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.black12,
          ),
        ],
      ),
      onTap: () {
        _showDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    this._context = context;
    return _build();
  }

  _showDialog() {

  }
}
