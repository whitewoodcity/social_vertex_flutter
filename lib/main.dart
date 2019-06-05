import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'search_interface.dart';
import 'user_interface.dart';
import 'utils/util.dart';

import 'register.dart';
import 'config/constants.dart' as constants;

void main() => runApp(Application()); //整个应用的入口

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
    MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (_) => HomePage(),
        "/register": (_) => RegisterPage(),
        "/login": (_) => UserInterface(),
        "/search": (_) => SearchInterface(),
      },
    );
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  TextEditingController id = TextEditingController();
  TextEditingController pw = TextEditingController();

  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      key: Key(constants.login),
      appBar: AppBar(
        title: Text("登录"),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: 50.0, left: 20.0, right: 20.0, bottom: 20.0),
              child: Align(
                child: LayoutBuilder(builder: (context, constraint) {
                  return Image.asset(
                    "assets/images/flutter.png",
                    width: constraint.biggest.width / 2,
                    height: constraint.biggest.width / 2,
                  );
                }),
                alignment: Alignment.center,
              ),
            ),
            Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    textAlign: TextAlign.start,
//                  onChanged: (value) => (state.id = value),
                    controller: id,
                    decoration: InputDecoration(labelText: "用户名："),
                  ),
                  TextFormField(
                    textAlign: TextAlign.start,
//                  onChanged: (value) => (state.password = value),
                    controller: pw,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "密码："),
                  ),
                  SizedBox.fromSize(
                    size: Size(0.00, 10.0),
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (id.text.trim() != "" && pw.text.trim() != "") {
                        var reqJson = {
                          constants.type: constants.user,
                          constants.subtype: constants.login,
                          constants.id: id.text.trim(),
                          constants.password: md5(pw.text.trim())
                        };
                        put("${constants.protocol}${constants.server}/",
                          headers: {"Content-Type": "application/json"},
                          body: json.encode(reqJson)).then((response) {
                          if (response.statusCode == 200) {
                            var result = json.decode(utf8.decode(response.bodyBytes));
                            result[constants.password] = md5(pw.text.trim());
                            if (result[constants.login]) {
                              Navigator.pushNamed(context, "/login", arguments: result);
                            } else {
                              showMessage("登录失败");
                            }
                          } else {
                            showMessage("服务器异常,请重试!");
                          }
                        },onError: (error)=>showMessage("服务器异常,请重试!"));
                      } else {
                        showMessage("用户名/密码不能为空！");
                      }
                    },
                    child: Text("登录"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
        (Navigator.pushNamed(context, "/register")
          .then((value) {
          if (value is Map) {
            Map map = value as Map<String, String>;
            if (map.containsKey(constants.id))
              id.text = map[constants.id];
            if (map.containsKey(constants.password))
              pw.text = map[constants.password];
          }
        })),
        child: Text("注册"),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    id.dispose();
    pw.dispose();
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
