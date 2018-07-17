import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_vertex_flutter/datamodel/contacts_model.dart';
import 'user.dart';
import 'component/contact_item.dart';

List<Entry> _list = new List();

Widget showContactsList(UserState state) {
  if (_list.isEmpty) _loadContacts();
  return new ListView.builder(
    itemBuilder: (BuildContext context, int index) =>
        new ContactItem(_list[index]),
    itemCount: _list.length,
  );
}

void _loadContacts() {
  //测试数据

  _list.add(
    new Entry(
      '我的好友',
      <Entry>[
        new Entry('小勇'),
      ],
    ),
  );
  _list.add(
    new Entry(
      '家人',
      <Entry>[
        new Entry('爸爸'),
        new Entry('妈妈'),
        new Entry("小宝")
      ],
    ),
  );
}
