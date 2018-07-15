import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_vertex_flutter/component/message_Item.dart';

class DialogStateless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(title: "dialog", home: new DialogStateful());
  }
}

class DialogStateful extends StatefulWidget {
  @override
  DialogState createState() => new DialogState();
}

class DialogState extends State<DialogStateful> {
  var _message = "";
  var _receiveMessage;
  List<MessageEntry> list = new List();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("小红"),
          centerTitle: true,
        ),
        body: new ListView(
          children:_messageManage() ,
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

  _sendMessage() {
    updata(new MessageEntry(_message));
  }
  _messageManage(){
    return list;
  }
  void updata(MessageEntry entry){
    setState(() {
      list.add(entry);
    });
  }
}
