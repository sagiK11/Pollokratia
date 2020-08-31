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
              color: Theme.of(context).appBarTheme.color,
            ),
            child: Text(
              AppLocalizations.of(context).translate("menu"),
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
          ),
          CustomListTile(icon: Icon(Icons.home), text: "home", navTo: "/Home"),
          CustomListTile(icon: Icon(Icons.chat), text: "check_list", navTo: "/CheckList"),
          CustomListTile(icon: Icon(Icons.info), text: "about", navTo: "/AboutMe"),
          CustomListTile(icon: Icon(Icons.edit), text: "create_mission", navTo: "/MissionCreation"),
          Container(
              color: Theme.of(context).backgroundColor,
              child: SizedBox(
                height: 250,
              ))
        ],
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final Icon icon;
  final String text;
  final String navTo;

  CustomListTile({this.icon, this.text, this.navTo});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
      ),
      child: ListTile(
        leading: icon,
        title: Text(AppLocalizations.of(context).translate(text),style: Theme.of(context)
            .textTheme.bodyText2,),
        onTap: () {
          Navigator.of(context).pushNamed(navTo);
        },
      ),
    );
  }
}
