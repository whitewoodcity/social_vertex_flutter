import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_vertex_flutter/user_info.dart';
import 'contacts_group.dart';
import 'person.dart';
import 'package:social_vertex_flutter/datamodel/contacts_model.dart';

class ContactItem extends StatelessWidget {
  ContactItem(this.entry);

  final Entry entry;
  BuildContext _context;

  Widget _buildTiles(Entry root) {
    if (root.list.isEmpty)
      return new GestureDetector(
        child: new ListTile(
          title: getPerson(root.title),
        ),
        onTap: () {
          Navigator.of(_context).push(
                new MaterialPageRoute(
                  builder: (BuildContext context) => new UserInfoStateful(root.title),
                ),
              );
        },
      );
    return new ExpansionTile(
      key: new PageStorageKey<Entry>(root),
      title: getGroup(root.title),
      children: root.list.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    this._context = context;
    return _buildTiles(entry);
  }
}
