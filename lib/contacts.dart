import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'utils/application_menu.dart';
import 'main.dart';

var mainState;

Widget getContactsList(MyHomePageState myHomePageState) {
  mainState = myHomePageState;
  return new Scaffold(
    appBar: new AppBar(
      title: new Text("联系人"),
      centerTitle: true,
    ),
    drawer: showAppMenu(),
    body: new ListView.builder(
      itemBuilder: (BuildContext context, int index) =>
          new EntryItem(data[index]),
      itemCount: data.length,
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
  //响应消息请求
  mainState.updateUi(1);
}

void _showContract() {
  //响应联系人请求
}

void selectContacts() {}

class Entry {
  final String title;
  final List<Entry> list;

  Entry(this.title, [this.list = const <Entry>[]]);
}

final List<Entry> data = <Entry>[
  new Entry(
    '我的好友',
    <Entry>[
      new Entry('小勇'),
    ],
  ),
  new Entry(
    '家人',
    <Entry>[
      new Entry('爸爸'),
      new Entry('妈妈'),
    ],
  ),
  new Entry(
    '同事',
    <Entry>[
      new Entry('小张'),
    ],
  ),
];

class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.list.isEmpty) return new ListTile(title: new Text(root.title));
    return new ExpansionTile(
      key: new PageStorageKey<Entry>(root),
      title: new Text(root.title),
      children: root.list.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
