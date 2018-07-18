import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_vertex_flutter/component/message_item.dart';

var _name;
class DialogStateful extends StatefulWidget {
  @override
  DialogState createState() => new DialogState();

  DialogStateful(name){
    _name=name;
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
          children:_list,
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
 
  void updata(MessageEntry entry){
    setState(() {
      _list=new List.from(_list);
      _list.add(new MessageEntry(_message));
    });
  }
}
