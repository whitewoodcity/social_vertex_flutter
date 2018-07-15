import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_vertex_flutter/main.dart';
import 'package:social_vertex_flutter/utils/keys.dart' as keys;

/// Usage:
/// ```Dart
/// new Scaffold(appBar: genAppBar(state,"title"));
/// ```
/*
///
genAppBar(MyHomePageState state, String title) {
  var appBar;
  if (Theme.of(state.context).platform == TargetPlatform.iOS) {
    appBar = _iOSAppBar(state, title);
  } else {
    appBar = _commonAppBar(title);
  }
  return appBar;
}

/// With [state] to go back for iOS Design.
_iOSAppBar(MyHomePageState state, String centerTitle) {
  return CupertinoNavigationBar(
      backgroundColor: Colors.blue,
      leading: CupertinoButton(
        child: new Text('返回', style: new TextStyle(color: Colors.white)),
        padding: EdgeInsets.zero,
        onPressed: () {
          state.updateUi(keys.login);
        },
      ),
      middle: new Text(centerTitle));
}

/// for Android and Fuchsia? Design
_commonAppBar(String centerTitle) {
  return new AppBar(
    title: Row(
      children: <Widget>[
        Expanded(
          child: new Center(
            child: new Text(centerTitle),
          ),
        ),
      ],
    ),
  );
}
*/
