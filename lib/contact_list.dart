import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_vertex_flutter/component/application_menu.dart';
import 'package:social_vertex_flutter/component/contacts_group.dart';
import 'package:social_vertex_flutter/component/person.dart';
import 'main.dart';

MyHomePageState _homeState;

Widget showContacts(MyHomePageState state) {
  _homeState = state;
  state.curChartTarget="";
  var _curPage = 1;
  return Scaffold(
    appBar: AppBar(
      title: Text("联系人"),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: InputDecorator(
            decoration: InputDecoration(icon: Icon(Icons.add)),
          ),
          onPressed: () {
            _homeState.updateUi(4);
          },
        ),
      ],
    ),
    drawer: Drawer(
      child: showAppMenu(state.nickname),
    ),
    body: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
            child: TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '搜索',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                      style: BorderStyle.solid),
                ),
              ),
              enabled: true,
            onSubmitted: (value){
                if(value!="") {
                  state.showUserInfo(5, value);
                }
            },
            ),

        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                ContactItem(_homeState.friends[index]),
            itemCount: _homeState.friends.length,
          ),
        ),
      ],
    ),
    bottomNavigationBar: BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            "assets/images/message.png",
            width: 30.0,
            height: 30.0,
          ),
          title: Text("消息"),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            "assets/images/contacts.png",
            width: 30.0,
            height: 30.0,
          ),
          title: Text("联系人"),
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          state.updateUi(1);
        }
      },
      currentIndex: _curPage,
    ),
  );
}

class ContactItem extends StatelessWidget {
  ContactItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.list.isEmpty)
      return GestureDetector(
        child: ListTile(
          title: getPerson(root.title),
        ),
        onTap: () {
          _homeState.showChat(root.title);
        },
      );
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: getGroup(root.title),
      children: root.list.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}

class ContactsModel {
  List<Entry> list;

  ContactsModel(this.list);
}

class Entry {
  final String title;
  final List<Entry> list;
  Entry(this.title, [this.list = const <Entry>[]]);
}
