import 'package:flutter/material.dart';
import 'contacts.dart';
import 'login.dart';
import 'user.dart';
import 'utils/keys.dart' as keys;

void main() => runApp(MyApplication()); //整个应用的入口

class MyApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "social-vertex-flutter", home: new MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  var stage = 0;

  @override
  Widget build(BuildContext context) {
    switch (stage) {
      case keys.user:
        return getUserCenter(this); //用户中心界面
      case keys.contacts:
        return getContactsList(this); //联系人界面
      default:
        return login(this); //登录界面
    }
  }

  void updateUi(int state) {
    //通知Flutter框架更新子Widget状态
    print(state);
    setState(() {
      stage = state;
    });
  }

  void showRegister() async {
    //弹出注册对话框
    var userName="";
    var password="";
    var repassword="";
    var information = "";
    await Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (BuildContext context) {
            return new AlertDialog(
              title: new Text("用户注册"),
              content: new Center(
                child: new ListView(
                  children: <Widget>[
                    new Text("用户名:"),
                    new TextField(
                      textAlign: TextAlign.start,
                      onChanged: (String value) {
                        print(value);
                        userName = value;
                      },
                    ),
                    new Text("密码:"),
                    new TextField(
                      textAlign: TextAlign.start,
                      obscureText: true,
                      onChanged: (String value) {
                        print(value);
                        password = value;
                      },
                    ),
                    new Text("确认密码:"),
                    new TextField(
                      obscureText: true,
                      onChanged: (String value) {
                        repassword = value;
                      },
                    ),
                    new SizedBox.fromSize(
                      size:Size(0.0, 10.0),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            onPressed: () {
                              print("hello");
                              if (!(userName == "") &&
                                  !(password == "") &&
                                  !(repassword == "")) {
                                if (password == repassword) {
                                  _register();
                                } else {
                                  information = "两次密码不匹配";
                                }
                              } else {
                                information = "输入输入信息不能为空";
                              }
                            },
                            child: Text("注册"),
                          ),
                        ),
                        Expanded(
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("取消"),
                          ),
                        )
                      ],
                    ),
                    new Row(
                      children: <Widget>[
                        new Expanded(
                            child: new FlatButton(
                                onPressed: null, child: new Text(information))),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
          settings: RouteSettings(name: "async", isInitialRoute: true),
        ));
  }

  void _register() {
    //新用户注册
  }
}
