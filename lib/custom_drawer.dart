import 'package:flutter/material.dart';
import 'app_localizations.dart';
import 'globals.dart' as globals;

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: globals.secondaryColor,
            ),
            child: Text(
              AppLocalizations.of(context).translate("menu"),
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFa8c6ea),
            ),
            child: ListTile(
              leading: Icon(Icons.home),
              title: Text(AppLocalizations.of(context).translate("home")),
              onTap: () {
                Navigator.pushNamed(context, '/Home');
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFa8c6ea),
            ),
            child: ListTile(
              leading: Icon(Icons.chat),
              title: Text(AppLocalizations.of(context).translate("check_list")),
              onTap: () {
                Navigator.pushNamed(context, '/CheckList');
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFa8c6ea),
            ),
            child: ListTile(
              leading: Icon(Icons.info),
              title: Text(AppLocalizations.of(context).translate("about")),
              onTap: () {
                Navigator.pushNamed(context, '/AboutMe');
              },
            ),
          ),
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: Color(0xFFa8c6ea),
            ),
            child: ListTile(
              leading: Icon(Icons.edit),
              title: Text(AppLocalizations.of(context).translate("create_mission")),
              onTap: () {
                Navigator.of(context).pushNamed('/MissionCreation');
              },
            ),
          ),
        ],
      ),
    );
  }
}
