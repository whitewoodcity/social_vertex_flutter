import 'package:flutter/material.dart';

class UserInterface extends StatefulWidget {
  @override
  UserInterfaceState createState() => UserInterfaceState();
}

class UserInterfaceState extends State<UserInterface> {

  TextEditingController id = TextEditingController();
  TextEditingController pw = TextEditingController();

  int index = -1;

  @override
  Widget build(BuildContext context) {
    if(index<0){
      final String arguments = ModalRoute.of(context).settings.arguments;
      List<String> params = arguments.split(" ");
      id.text = params[0];
      pw.text = params[1];
      index = 0;
    }
    print(id.text);
    print(index);

    return Scaffold(
      appBar: AppBar(
        title: Text("好友列表"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: InputDecorator(
              decoration: InputDecoration(icon: Icon(Icons.add)),
            ),
            onPressed: () {

            },
          ),
        ],
      ),
      drawer: Drawer(
        child: showAppMenu(this),
      ),
      body: null,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            title: Text("消息"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box), title: Text("好友")),
        ],
        onTap: (index) => setState(() => this.index = index),
        currentIndex: index,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    id.dispose();
    pw.dispose();
  }

  showAppMenu(UserInterfaceState state) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 100.0,
                  child: Image.asset("assets/images/flutter.png"),
                ),
              ],
            ),
            color: Colors.blue,
            height: 100.0,
          ),
          Text(
            "昵称",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: "微软雅黑",
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_upload), title: Text("更新")),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app), title: Text("退出"))
        ],
        onTap: (value) {
          print(value);
          if(value == 1){
            Navigator.popUntil(context, ModalRoute.withName('/main'));
          }
        },
        currentIndex: 1,
      ),
    );
  }


}