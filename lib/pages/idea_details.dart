import 'package:flutter/material.dart';
import '../app_localizations.dart';

class AppIdea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'more-details',
      child: Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context).translate("more_details"))),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: Text(
                        AppLocalizations.of(context).translate("app_idea_first_paragraph"),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Text(
                        AppLocalizations.of(context).translate("app_idea_second_paragraph"),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Text(
                        AppLocalizations.of(context).translate("app_idea_third_paragraph"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
