import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'config/constants.dart' as constants;

class SearchInterface extends StatefulWidget {
  @override
  SearchInterfaceState createState() => SearchInterfaceState();
}

class SearchInterfaceState extends State<SearchInterface> {

  TextEditingController keyword = TextEditingController();
  var httpClient = HttpClient();

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
                    onPressed: () async {
                      var req = {
                        constants.type: constants.search,
                        constants.keyword: keyword.text.trim(),
                        constants.version: constants.currentVersion
                      };
                      httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
                      var request = await httpClient.putUrl(Uri.parse("${constants.protocol}${constants.server}/${constants.search}"));
                      request.write(json.encode(req) + constants.end);
                      var response = await request.close();
                      if (response.statusCode == 200) {
                        response.transform(utf8.decoder).listen((data) {
                          var result = json.decode(data);
                          print(result);
                        });
                      } else {
                        this.showMessage("服务器错误!");
                      }
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
    super.dispose();
    httpClient.close(force: true);
    keyword.dispose();
  }

  void showMessage(String message) {
    //显示系统消息
    showDialog(
      context: context,
      builder: (BuildContext context) =>
        SimpleDialog(
//              title: Text("消息"),
          children: <Widget>[
            Center(
              child: Text(message),
            )
          ],
        ));
  }
}