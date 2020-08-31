import 'package:flutter/material.dart';
import 'package:pollokratia/custom_drawer.dart';
import '../app_localizations.dart';
import '../globals.dart' as globals;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).translate("home")),backgroundColor:
      Theme.of(context).appBarTheme.color,),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(globals.backgroundColor), fit: BoxFit.fill),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 60,
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                    width: screenHeight - 20,
                    child: Text(
                      AppLocalizations.of(context).translate("home_page_title"),
                      style: Theme.of(context).textTheme.headline6,
                    )),
                SizedBox(
                  height: 10,
                ),
                Container(
                  //color: Colors.grey[100],
                  width: 300,
                  child: Text(
                    AppLocalizations.of(context).translate("home_page_text"),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Column(
                          children: <Widget>[
                            Container(
                              color: Theme.of(context).backgroundColor,
                              child: Center(
                                child: FlatButton(
                                  onPressed: () => Navigator.pushNamed(context, '/CheckList'),
                                  child: Text(
                                    AppLocalizations.of(context).translate("start_now"),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Column(
                          children: <Widget>[
                            Container(
                              color: Colors.white,
                              child: Center(
                                child: Hero(
                                  tag: 'more-details',
                                  child: FlatButton(
                                    onPressed: () => Navigator.pushNamed(context, '/AppIdea'),
                                    child: Text(
                                      AppLocalizations.of(context).translate("more_details"),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
