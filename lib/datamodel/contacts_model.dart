class ContactsModel {
  List<Entry> list;

  ContactsModel(this.list);
}

class Entry {
  final String title;
  final List<Entry> list;

  Entry(this.title, [this.list = const <Entry>[]]);
}
