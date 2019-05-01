import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('smoke test', (WidgetTester tester) async {
    List<String> items = [];
    var i = (items..add("test")).removeLast();

    print(i);
  });
}