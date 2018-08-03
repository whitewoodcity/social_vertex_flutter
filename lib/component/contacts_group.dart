import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

getGroup(String title) {
  return Row(
    children: <Widget>[
      Column(
        children: <Widget>[
          Image.asset(
            "assets/images/group.png",
            width: 30.0,
            height: 30.0,
          ),
        ],
      ),
      Column(
        children: <Widget>[
          Text(title),
        ],
      ),
    ],
  );
}
