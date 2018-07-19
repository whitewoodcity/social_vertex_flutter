import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_vertex_flutter/component/application_menu.dart';
import 'package:social_vertex_flutter/component/contacts_group.dart';
import 'package:social_vertex_flutter/component/person.dart';
import 'datamodel/contacts_model.dart';
import 'main.dart';
import 'package:social_vertex_flutter/search.dart';

MyHomePageState _homeState;

Widget showContacts(MyHomePageState state, List<Entry> list) {
  _homeState = state;
  if(list.length==0) loadData();
  var _curPage = 1;
  return new Scaffold(
    appBar: new AppBar(
      title: new Text("联系人"),
      centerTitle: true,
      actions: <Widget>[
        new IconButton(
          icon: new InputDecorator(
            decoration: new InputDecoration(icon: new Icon(Icons.add)),
          ),
          onPressed: () {
            Navigator.of(_homeState.context).push(new MaterialPageRoute(
                builder: (BuildContext context) => new SearchStateful()));
          },
        ),
      ],
    ),
    drawer: new Drawer(
      child: showAppMenu(state.userName),
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
      onTap: (index) {
        if (index == 0) {
          state.updateUi(1);
        }
      },
      currentIndex: _curPage,
    ),
  );
}
void loadData(){
  var getFriendList = ''' {
    "type":"friend",
    "action":"list",
    "from":"${_homeState.userName}",
    "version":0.1
  }''';
  _homeState.sendMessage(getFriendList);
}

class ContactItem extends StatelessWidget {
  ContactItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.list.isEmpty)
      return new GestureDetector(
        child: new ListTile(
          title: getPerson(root.title),
        ),
        onTap: () {
          _homeState.showChat(root.title);
        },
      );
    return new ExpansionTile(
      key: new PageStorageKey<Entry>(root),
      title: getGroup(root.title),
      children: root.list.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
