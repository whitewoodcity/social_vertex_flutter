import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_vertex_flutter/datamodel/contacts_model.dart';
import 'package:social_vertex_flutter/search.dart';
import 'component/contact_item.dart';
import 'component/application_menu.dart';
import 'main.dart';

var mainState;
List<Entry> list = new List();

Widget getContactsList(MyHomePageState myHomePageState) {
  if (list.isEmpty) _loadContacts();
  mainState = myHomePageState;
  return new Scaffold(
    appBar: new AppBar(
      title: new Text("联系人"),
      centerTitle: true,
      actions: <Widget>[
        new IconButton(
            icon: new InputDecorator(
              decoration: new InputDecoration(icon: new Icon(Icons.add)),
            ),
            onPressed: _showAddFriend),
      ],
    ),
    drawer: new Drawer(
      child: showAppMenu(),
    ),
    body: new ListView.builder(
      itemBuilder: (BuildContext context, int index) =>
          new ContactItem(list[index]),
      itemCount: list.length,
    ),
    bottomNavigationBar: new BottomNavigationBar(
      items: [
        new BottomNavigationBarItem(
            icon: new Image.asset(
              "resources/images/message.png",
              width: 30.0,
              height: 30.0,
            ),
            title: new Text("消息")),
        new BottomNavigationBarItem(
            icon: new Image.asset(
              "resources/images/contacts.png",
              width: 30.0,
              height: 30.0,
            ),
            title: new Text("联系人")),
      ],
      onTap: (value) {
        if (value == 0) {
          _showMessage();
        }
      },
      currentIndex: 1,
    ),
  );
}

void _showMessage() {
  mainState.updateUi(1);
}

void selectContacts() {}

void _loadContacts() {
  //测试数据

  list.add(new Entry(
    '我的好友',
    <Entry>[
      new Entry('小勇'),
    ],
  ));
  list.add(
    new Entry(
      '家人',
      <Entry>[
        new Entry('爸爸'),
        new Entry('妈妈'),
      ],
    ),
  );
}

_showAddFriend() {
  Navigator.of(mainState.context).push(new MaterialPageRoute(
      builder: (BuildContext context) => SearchStateless()));
}
