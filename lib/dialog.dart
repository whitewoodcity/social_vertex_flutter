import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_vertex_flutter/component/message_Item.dart';
import 'package:social_vertex_flutter/user.dart';

var _targetName;
class DialogStateful extends StatefulWidget {

  @override
  DialogState createState() => new DialogState();

  DialogStateful(targetName){
    _targetName=targetName;
  }
}

class DialogState extends State<DialogStateful> {
  var _message = "";
  var _receiveMessage;
  var _source = "own";
  List<Widget> _list = [];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("${_targetName}"),
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
      ),
    );
  }

  _sendMessage() {
    update(new MessageEntry(_message, _source));
  }

  void update(MessageEntry entry) {
    _list = new List.from(_list);
    setState(() {
      _list.add(new MessageEntry(_message, _source));
    });
  }
}
