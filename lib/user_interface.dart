import 'package:flutter/material.dart';

class UserInterface extends StatefulWidget {



  @override
  UserInterfaceState createState() => UserInterfaceState();

  UserInterface();
}

class UserInterfaceState extends State<UserInterface> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("用户注册"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          TextField(
            textAlign: TextAlign.start,
            onChanged: (value) {

            },
            decoration: InputDecoration(labelText: "用户名"),
          ),
          TextField(
            textAlign: TextAlign.start,
            obscureText: true,
            onChanged: (String value) {

            },
            decoration: InputDecoration(labelText: "密码"),
          ),
          TextField(
            obscureText: true,
            onChanged: (String value) {

            },
            decoration: InputDecoration(labelText: "确认密码"),
          ),
          TextField(
            onChanged: (String value) {

            },
            decoration: InputDecoration(labelText: "昵称"),
          ),
          SizedBox.fromSize(
            size: Size(0.0, 10.0),
          ),
          Center(
            child: RaisedButton(
              onPressed: () {

              },
              child: Text("注册"),
            ),
          ),
        ],
      ),
    );
  }

}