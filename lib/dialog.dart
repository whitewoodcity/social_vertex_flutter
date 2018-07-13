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
        title: new Stack(
          alignment: Alignment.center,
          children: <Widget>[
            new Text("小红"),
            Align(
              alignment: Alignment.centerLeft,
              child: BackButton(),
            ),
          ],
        ),
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
    );
  }

  void _sendMessage() async {}
}
