import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'customIcon/my_flutter_app_icons.dart';
import 'list_item.dart';
import 'screen_message.dart';

class ChatPages extends StatefulWidget {
  @override
  _ChatPagesState createState() => _ChatPagesState();
}

class _ChatPagesState extends State<ChatPages> {
  final pages = <PropertyPage>[
    PropertyPage(Icons.book_sharp, 'Journal', <ListItem<String>>[]),
    PropertyPage(Icons.import_contacts_rounded, 'Notes', <ListItem<String>>[]),
    PropertyPage(Icons.nature_people, 'Gratitude', <ListItem<String>>[]),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: pages.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) return _buildBot();
          return _buildRow(pages[i - 1]);
        },
        separatorBuilder: (context, index) => Divider());
  }

  Widget _buildBot() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(
            MyFlutterApp.smart_toy_24px,
            size: 30,
          ),
          Text(
            'Questionnaire Bot',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.green[50],
      ),
      margin: EdgeInsetsDirectional.only(start: 30.0, top: 5.0, end: 30.0),
      width: 200,
      height: 50,
    );
  }

  Widget _buildRow(PropertyPage page) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context,
          ScreenMessage.routeName,
          arguments: page,
        );
      },
      child: ListTile(
        title: Text(
          page.title,
        ),
        subtitle: Text('No Events. Click to create one.'),
        horizontalTitleGap: 5.0,
        contentPadding: EdgeInsets.all(5.0),
        leading: Container(
          width: 75,
          height: 75,
          child: Icon(
            page.icon,
            color: Colors.white,
          ),
          decoration: BoxDecoration(
            color: Theme
                .of(context)
                .primaryColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class PropertyPage {
  final IconData _icon;
  final String _title;
  final List<ListItem<String>> _message;

  PropertyPage(this._icon, this._title, this._message);

  String get title => _title;

  List<ListItem<String>> get message => _message;

  IconData get icon => _icon;
}
