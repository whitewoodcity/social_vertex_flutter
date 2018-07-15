import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'contacts_group.dart';
import 'person.dart';
import 'package:social_vertex_flutter/datamodel/contacts_model.dart';

class ContactItem extends StatelessWidget {
  const ContactItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.list.isEmpty) return new ListTile(title: getPerson(root.title));
    return new ExpansionTile(
      key: new PageStorageKey<Entry>(root),
      title: getGroup(root.title),
      children: root.list.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
