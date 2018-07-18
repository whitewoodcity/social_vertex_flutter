import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_vertex_flutter/component/message_item.dart';
import 'package:social_vertex_flutter/config/config.dart' as config;
import 'package:social_vertex_flutter/datamodel/user_info.dart' as user;

var _name;

class DialogStateful extends StatefulWidget {
  @override
  DialogState createState() => new DialogState();

  DialogStateful(name) {
    _name = name;
  }
}

class DialogState extends State<DialogStateful> {
  var _message = "";
  List<MessageEntry> _list = new List();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(_name),
          centerTitle: true,
        ),
        body: new ListView(
          children: _list,
        ),
        bottomNavigationBar: new BottomAppBar(
          child: new Row(
            children: <Widget>[
              new Expanded(child: new TextField(
                onChanged: (value) {
                  _message = value;
                },
              )),
              new RaisedButton(
                onPressed: _sendMessage,
                child: new Text("发送"),
              )
            ],
          ),
        ));
  }

  _sendMessage() async {
    updata(new MessageEntry(_message));
    var message = '''{
     "type":"message",
    "from":"${user.id}",
    "to":"${_name}",
    "body":"${_message}",
    "version":0.1
    }''';
    print(message);
    Socket socket = null;
    if (socket != null) socket.destroy();
    try {
      socket = await Socket.connect(config.host, config.tcpPort);
      socket.write(message);
      socket.forEach(
        (package) {
          var backInf = json.decode(utf8.decode(package));
          print(backInf);
          var status = backInf["info"];
          if (status != null&&status=="Ok") {
            updata(new MessageEntry(backInf["body"]));
          } else {
            _showMessage("发送失败...");
          }
        },
      ).timeout(new Duration(seconds: 5000), onTimeout: () {
        _showMessage("网络连接超时...");
      });
    } catch (e) {
      _showMessage("网络好像不可用....");
    }
  }

  void updata(MessageEntry entry) {
    setState(() {
      _list = new List.from(_list);
      _list.add(new MessageEntry(_message));
    });
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => new SimpleDialog(
            title: new Text("消息"),
            children: <Widget>[
              new Center(
                child: new Text(message),
              ),
            ],
          ),
    );
  }
}
