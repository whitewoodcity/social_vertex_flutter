import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_vertex_flutter/search.dart';
import 'contact_list.dart';
import 'message_list.dart';

class UserStateful extends StatefulWidget {
  @override
  UserState createState() => new UserState();
}

class UserState extends State<UserStateful> {
  int _curPage = 0;
  var context;
  var title = "消息";

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
            icon: new InputDecorator(
              decoration: new InputDecoration(icon: new Icon(Icons.add)),
            ),
            onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new SearchStateful()));
            },
          ),
        ],
      ),
      body: _curPage == 0 ? showMessageList(this) : showContactsList(this),
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
              icon: new Image.asset(
                "assets/images/message.png",
                width: 30.0,
                height: 30.0,
              ),
              title: new Text("消息")),
          new BottomNavigationBarItem(
              icon: new Image.asset(
                "assets/images/contacts.png",
                width: 30.0,
                height: 30.0,
              ),
              title: new Text("联系人")),
        ],
        onTap: (value) {
          update(value);
        },
        currentIndex: _curPage,
      ),
    );
  }

  void update(int status) {
    setState(() {
      _curPage = status;
    });
  }
}
