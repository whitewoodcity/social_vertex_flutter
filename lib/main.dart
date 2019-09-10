import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'config/ui_variables.dart';
import 'search_interface.dart';
import 'user_interface.dart';
import 'utils/util.dart';

import 'register.dart';
import 'config/constants.dart' as constants;
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;

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

  void initState() {
    super.initState();
    Locale locale = ui.window.locale == null ? ui.window.locale : Locale.fromSubtags();
    loadSystemUIVariables(locale);
  }

  void loadSystemUIVariables(Locale locale) {
    if (locale == null) return;
    rootBundle.loadString("assets/i18n/$locale.json")
      .then((string) => setState(() => uiVariables = json.decode(string)))
      .catchError((error) {
      var scriptCode = locale.scriptCode == null ? "" : "_${locale.scriptCode}";
      rootBundle.loadString("assets/i18n/${locale.languageCode}$scriptCode.json")
        .then((string) => setState(() => uiVariables = json.decode(string)))
        .catchError((error) =>
        rootBundle.loadString("assets/i18n/${locale.languageCode}.json")
          .then((string) => setState(() => uiVariables = json.decode(string)))
          .catchError((e) {})
      );
    });
  }

  void loadUIVariablesByString(String param) {
    rootBundle.loadString("assets/i18n/$param.json")
      .then((string) => setState(() => uiVariables = json.decode(string)));
  }

  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    List<DropdownMenuItem<String>> languageList = [];
    for (int i = 0; i < languageValues.length; i++) {
      languageList.add(DropdownMenuItem(
        value: languageValues[i],
        child: Text(languageDescriptions[i])
      ));
    }

    return Scaffold(
      key: Key(constants.login),
      appBar: AppBar(
        title: Text(uiVariables["login"]),
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
                    decoration: InputDecoration(labelText: uiVariables["username"]),
                  ),
                  TextFormField(
                    textAlign: TextAlign.start,
//                  onChanged: (value) => (state.password = value),
                    controller: pw,
                    obscureText: true,
                    decoration: InputDecoration(labelText: uiVariables["password"]),
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
                              showMessage(uiVariables["login_fail"]);
                            }
                          } else {
                            showMessage(uiVariables["system_error"]);
                          }
                        }, onError: (error) => showMessage(uiVariables["system_error"]));
                      } else {
                        showMessage(uiVariables["user_pw_null"]);
                      }
                    },
                    child: Text(uiVariables["login"]),
                  ),
                  DropdownButton(
                    value: uiVariables["language"],
                    items: languageList,
                    onChanged: (language) =>
                      rootBundle.loadString("assets/i18n/$language.json")
                        .then((string) => setState(() => uiVariables = json.decode(string)))),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 75.0,
        height: 75.0,
        child: FloatingActionButton(
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
          child: Text(uiVariables["register"]),
        ),
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
    showDialog(
      context: context,
      builder: (BuildContext context) =>
        SimpleDialog(
          children: <Widget>[
            Center(
              child: Text(message),
            )
          ],
        ));
  }
}
