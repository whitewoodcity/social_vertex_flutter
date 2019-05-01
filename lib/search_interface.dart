import 'dart:io';

import 'package:flutter/material.dart';
import 'config/constants.dart' as constants;

class SearchInterface extends StatefulWidget {
  @override
  SearchInterfaceState createState() => SearchInterfaceState();
}

class SearchInterfaceState extends State<SearchInterface> {

  TextEditingController keyword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Widget> itemList = [];

    return Scaffold(
      appBar: AppBar(
        title: Text("搜索"),
        centerTitle: true,
        leading: IconButton(
          icon: InputDecorator(
            decoration: InputDecoration(
              icon: Icon(Icons.arrow_back),
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[ //itemList
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: keyword,
                  ),
                  flex: 8,
                ),
                Expanded(
                  child: RaisedButton(
                    onPressed: () {

                    },
                    child: Text("搜索"),
                  ),
                  flex: 2,
                )
              ],
            )),
          Expanded(child: ListView(children: itemList)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    keyword.dispose();
  }
}