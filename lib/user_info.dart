import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'main.dart';

MyHomePageState _homeState;

Widget showInfo(MyHomePageState state, String keyWord, List<Widget> list) {
  _homeState = state;
  return Scaffold(
    appBar: AppBar(
      title: Text("搜索"),
      centerTitle: true,
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _homeState.updateUi(2);
          }),
    ),
    body: TabBarView(
      children: list,
      controller: TabController(length: list.length, vsync: MyTicker()),
    ),
  );
}

class MyTicker extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) {
    Ticker ticker = Ticker(onTick);
    return ticker;
  }
}

class UserInfoItem extends StatefulWidget {
  final UserInfoModel user;

  UserInfoItem(this.user);

  @override
  UserInfoState createState() => UserInfoState(user);
}

class UserInfoState extends State<UserInfoItem> {
  final UserInfoModel user;

  UserInfoState(this.user);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            ClipRect(
              child: Container(
                width: 100.0,
                height: 100.0,
                child: IconButton(
                  icon: Image.asset(
                    "assets/images/user.png",
                    width: 100.0,
                    height: 100.0,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  Text(
                    "用户Id：${user.id}",
                    style: TextStyle(fontSize: 18.0),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "账号：${user.name}",
                    style: TextStyle(fontSize: 18.0),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfoModel {
  //用户信息
  String _id;
  String _name;

  UserInfoModel({String id, String name}) {
    _id = id;
    _name = name;
  }

  String get name => _name;

  String get id => _id;
}
