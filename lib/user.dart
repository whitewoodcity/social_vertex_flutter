import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_vertex_flutter/component/application_menu.dart';
import 'main.dart';
import 'package:social_vertex_flutter/search.dart';
import 'message_list.dart';

MyHomePageState homeState;

Widget showUser(MyHomePageState state) {
  homeState = state;
  int _curPage = 0;
  return new Scaffold(
    appBar: new AppBar(
      title: new Text("消息"),
      centerTitle: true,
      actions: <Widget>[
        new IconButton(
          icon: new InputDecorator(
            decoration: new InputDecoration(icon: new Icon(Icons.add)),
          ),
          onPressed: () {
            Navigator.of(homeState.context).push(new MaterialPageRoute(
                builder: (BuildContext context) => new SearchStateful()));
          },
        ),
      ],
    ),
    drawer: new Drawer(
      child: showAppMenu(homeState.userName),
    ),
    body: showMessageList(homeState),
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
      onTap: (index){
        if(index==1){
          state.updateUi(2);
        }
      },
      currentIndex: _curPage,
    ),
  );
}
