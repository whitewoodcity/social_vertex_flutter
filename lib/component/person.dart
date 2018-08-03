import 'package:flutter/cupertino.dart';

getPerson(String name) {
  return Row(
    children: <Widget>[
      Column(
        children: <Widget>[
          Image.asset(
            "assets/images/person.png",
            width: 20.0,
            height: 20.0,
          )
        ],
      ),
      Column(
        children: <Widget>[Text(name)],
      )
    ],
  );
}
