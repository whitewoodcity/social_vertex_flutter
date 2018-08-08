import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'config/constants.dart' as constants;

MyHomePageState homePageState;

Widget showSystemInfo(
    MyHomePageState homePage) {
  homePageState = homePage;
  return Scaffold(
    appBar: AppBar(
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            homePage.updateUi(1);
          }),
      title: Text("系统消息"),
      centerTitle: true,
    ),
    body: ListView.builder(
        itemBuilder: (BuildContext context, int index) => SystemInfo(
            homePage.systemInfoList[index].type, homePage.systemInfoList[index].info, homePage.systemInfoList[index].to),
        itemCount: homePage.systemInfoList.length),
  );
}

class SystemInfoModel {
  String type;
  String info;
  String to;

  SystemInfoModel({String type, String info, String to}) {
    this.type = type;
    this.info = info;
    this.to = to;
  }
}

class SystemInfo extends StatefulWidget {
  final String type;
  final String info;
  final String to;

  SystemInfo(this.type, this.info, this.to);

  @override
  SystemInfoItem createState() => SystemInfoItem(type, info, to);
}

class SystemInfoItem extends State<SystemInfo> {
  final String type;
  final String info;
  final String to;

  SystemInfoItem(this.type, this.info, this.to);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: Text(
            type,
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 20.0, decorationStyle: TextDecorationStyle.solid),
          ),
        ),
        Text(
          info==null?"???":info,
          textAlign: TextAlign.left,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("同意"),
              onPressed: () {
                var agree = {
                  constants.type: constants.friend,
                  constants.subtype: constants.response,
                  constants.to: "$to",
                  constants.accept: true,
                  constants.version: "0.2"
                };
                homePageState.sendMessage(json.encode(agree) + "\r\n");
              },
            ),
            SizedBox(
              width: 10.0,
            ),
            RaisedButton(
              child: Text("拒绝"),
              onPressed: () {
                var refuse = {
                  constants.type: constants.friend,
                  constants.subtype: constants.response,
                  constants.to: "$to",
                  constants.accept: false,
                  constants.version: constants.currentVersion
                };
                homePageState.sendMessage(json.encode(refuse) + constants.end);
              },
            )
          ],
        )
      ],
    );
  }
}
