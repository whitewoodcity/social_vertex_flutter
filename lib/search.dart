import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:social_vertex_flutter/component/search_item.dart';

class SearchStateless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(title: "搜索", home: new SearchStateful());
  }
}

class SearchStateful extends StatefulWidget {
  @override
  SearchState createState() => new SearchState();
}

class SearchState extends State<SearchStateful> {
  var _searchType;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("添加"),
        centerTitle: true,
        leading: new IconButton(
            icon: new InputDecorator(
              decoration: new InputDecoration(icon: new Icon(Icons.arrow_back)),
            ),
            onPressed:(){
              Navigator.pop(context);
            }),
      ),
      body: new Scaffold(
        appBar: new AppBar(
          title: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(),
                flex: 8,
              ),
              new Expanded(
                child: new RaisedButton(
                  onPressed: _search,
                  child: new Text("搜索"),
                ),
                flex: 2,
              )
            ],
          ),
          backgroundColor: Colors.white70,
        ),
        body: new ListView(
          children: <Widget>[showSearchItem("骄阳似火(752544765@qqcom)", context)],
        ),
      ),
    );
  }

  void _search() {

  }
}
