import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title:new Text("小红"),
        centerTitle: true,
      ),
      body: new ListView(
        children: <Widget>[
          new Text(
            "hello",
            textAlign: TextAlign.start,
          ),
          new Text(
            "hello",
            textAlign: TextAlign.end,
          ),
        ],
      ),
      bottomNavigationBar:new BottomAppBar(
        child: new Row(
          children: <Widget>[
            new Expanded(child: new TextField(

            )),
            new RaisedButton(
              onPressed: _sendMessage,child: new Text("发送"),
            )
          ],
        ),
      )
    );
  }

  void _sendMessage() async {

  }
}
