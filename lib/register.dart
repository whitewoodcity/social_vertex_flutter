import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'config/ui_variables.dart';
import "config/constants.dart" as constants;
import 'utils/util.dart' as util;

class RegisterPage extends StatefulWidget {

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<RegisterPage> {
  String _userName = "";
  String _password = "";
  String _repassword = "";
  String _nickname = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(uiVariables["register"]),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          TextField(
            textAlign: TextAlign.start,
            onChanged: (value) => _userName = value,
            decoration: InputDecoration(labelText: uiVariables["username"]),
          ),
          TextField(
            textAlign: TextAlign.start,
            obscureText: true,
            onChanged: (String value) => _password = value,
            decoration: InputDecoration(labelText: uiVariables["password"]),
          ),
          TextField(
            obscureText: true,
            onChanged: (String value) => _repassword = value,
            decoration: InputDecoration(labelText: uiVariables["pw_confirm"]),
          ),
          TextField(
            onChanged: (String value) => _nickname = value,
            decoration: InputDecoration(labelText: uiVariables["nickname"]),
          ),
          SizedBox.fromSize(
            size: Size(0.0, 10.0),
          ),
          Center(
            child: RaisedButton(
              onPressed: () {
                if (_userName != "" && _password != "" && _repassword != "") {
                  if (_password == _repassword) {
                    _register(context);
                  } else {
                    _registerAlert(uiVariables["pw_not_match"]);
                  }
                } else {
                  _registerAlert(uiVariables["info_incomplete"]);
                }
              },
              child: Text(uiVariables["register"]),
            ),
          ),
        ],
      ),
    );
  }

  void _register(BuildContext context) async {
    var info = {
      constants.type: constants.user,
      constants.subtype: constants.register,
      constants.id: "$_userName",
      constants.password: "${util.md5(_userName+_password)}",
      constants.password2: "${util.md5(_userName+_repassword)}",
      constants.nickname: "$_nickname",
      constants.version: constants.currentVersion
    };

    put("${constants.protocol}${constants.server}/",
            headers: {"Content-Type": "application/json"}, body: json.encode(info) + constants.end)
        .then((response) {
      if (response.statusCode == 200) {
        var result = json.decode(utf8.decode(response.bodyBytes));
        if (result[constants.register]) {
          Navigator.popAndPushNamed(context, "/login", result: {
            constants.id: _userName,
            constants.password: _password
          }, arguments: {
            constants.id: _userName,
            constants.password: util.md5(_userName+_password),
            constants.nickname: _nickname
          });
        } else {
          _registerAlert(result["info"]);
        }
      } else {
        _registerAlert(uiVariables["system_error"]);
      }
    }).catchError((error) => print(error));
  }

  void _registerAlert(String info) {
    showDialog(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
            title: Text(uiVariables["msg"]),
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(info),
              ),
              SizedBox.fromSize(
                size: Size(0.00, 10.00),
              ),
              Align(
                alignment: Alignment.center,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(uiVariables["ok"]),
                ),
              ),
            ],
          ),
    );
  }
}
