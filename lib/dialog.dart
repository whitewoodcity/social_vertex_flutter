import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'utils/util.dart';
import 'config/constants.dart' as constants;
import 'main.dart';

var _message = "";
bool loadingHistory = false;

initChatDialog(MyHomePageState state){
  state.unreadMsgs.remove(state.friendId);
  state.updateUI(constants.dialog);
  loadHistoricalMessages(state);
}

loadHistoricalMessages(MyHomePageState state){
  if(loadingHistory) return;
  loadingHistory = true;

  var friend = state.friendId;
  var message = {
    constants.id:state.id,
    constants.password:md5(state.password),
    constants.friend:friend
  };

  if(state.messages.containsKey(friend)){
    List messages = state.messages[friend];
    if(messages.length>0){
      for(int i =messages.length - 1;i>=0;i--){
        Map msg = messages[i];
        if(msg.containsKey(constants.date)){
          message[constants.date] = msg[constants.date];
          break;
        }
      }
    }
  }

  put("${constants.protocol}${constants.server}/${constants.user}/${constants.history}",
      body: json.encode(message) + constants.end)
      .then((response) {
    loadingHistory = false;
    if (response.statusCode == 200) {
      Map resultMap = json.decode(utf8.decode(response.bodyBytes));
      List msgs = resultMap[constants.messages];
      if(!state.messages.containsKey(friend)){
        state.messages[friend] = [];
      }
      int i = msgs.length - 1;
      loop: for(;i>=0;i--){
        Map msg = msgs[i];
        if(msg.containsKey(constants.uuid)){
          //去重
          String uuid = msg[constants.uuid];

          bool msgExisted = false;

          for(Map m in state.messages[friend]){
            if(m.containsKey(constants.uuid) && m[constants.uuid] == uuid){
              msgExisted = true;
              break;
            }
          }

          if(!msgExisted){
            break loop;
          }
        }
      }
      state.messages[friend].addAll(msgs.sublist(0,i+1).reversed.toList());
      state.updateCurrentUI();
    }
  });

}

Widget showChatDialog(MyHomePageState state,[String message]) {

  if(!state.messages.containsKey(state.friendId)){
    state.messages[state.friendId] = [];
  }

  var messages = state.messages[state.friendId];

  var _scrollController = new ScrollController();

  _scrollController.addListener(
          () {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.position.pixels;
        double delta = 100.0; // or something else..
        if ( currentScroll - maxScroll >= delta) { // whatever you determine here
          loadHistoricalMessages(state);
        }
      }
  );

  ListView content = ListView.builder(
    padding: EdgeInsets.all(10.0),
    controller: _scrollController,
    itemBuilder: (BuildContext context, int index) {
      Map item = messages[index];

      var textAlign = TextAlign.start;
      if(item[constants.from] == state.id){
        textAlign = TextAlign.end;
      }

      var text = "";
//      if(item[constants.date]!=null && item[constants.time]!=null){
//        text += "${item[constants.date]} ${item[constants.time]}\n";
//      }
      text += "${item[constants.from]}:\n${item[constants.body]}";

      var row = Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("$text", textAlign: textAlign,),
            ),
          ),
        ],
      );

      if(item[constants.from] == state.id){
        row.children.add(Icon(Icons.message));
      }else{
        row.children.insert(0, Icon(Icons.message));
      }

      return row;
    },
    itemCount: messages.length,
  );

  return Scaffold(
    appBar: AppBar(
      title: Text(state.friendNickname == null ? state.friendId : state.friendNickname.trim()),
      centerTitle: true,
      leading: IconButton(
          icon: InputDecorator(
            decoration: InputDecoration(icon: Icon(Icons.arrow_back)),
          ),
          onPressed: () {
            state.updateUI(constants.userPage);
          }),
    ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: content,
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    _message = value;
                  },
                  controller: TextEditingController(
                    text: _message,
                  ),
                ),
              ),
              RaisedButton(
                child: Text("发送"),
                onPressed: () {
                  var message = {
                    constants.type: constants.message,
                    constants.subtype: constants.text,
                    constants.from: state.id,
                    constants.to: state.friendId,
                    constants.body: _message,
                    constants.uuid: uuid(),
                    constants.version: constants.currentVersion,
                  };
                  state.messages[state.friendId].insert(0,message);
                  state.updateCurrentUI();
                  state.sendMessage(json.encode(message));
                  _message = "";
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
