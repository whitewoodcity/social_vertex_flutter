import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('smoke test', (WidgetTester tester) async {
    Map map = json.decode("{}");
    print(map);
  });
}