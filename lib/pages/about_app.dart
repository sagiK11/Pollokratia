import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../app_localizations.dart';

class AboutMe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).translate("about"))),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 5,
                  ),
                  titleText(AppLocalizations.of(context).translate("about_app_title")),
                  SizedBox(
                    height: 20,
                  ),
                  paragraphText(AppLocalizations.of(context).translate("terms_of_service")),
                  SizedBox(
                    height: 10,
                  ),
                  paragraphText(AppLocalizations.of(context).translate("terms_of_service_text")),
                  SizedBox(
                    height: 20,
                  ),
                  paragraphText(AppLocalizations.of(context).translate("privacy_policy")),
                  SizedBox(
                    height: 10,
                  ),
                  paragraphText(AppLocalizations.of(context).translate("privacy_policy_text")),
                  paragraphText(AppLocalizations.of(context).translate("we_value_your_privacy")),
                  SizedBox(
                    height: 20,
                  ),
                  paragraphText(AppLocalizations.of(context).translate("thank_you")),
                  SizedBox(
                    height: 10,
                  ),
                  paragraphText(AppLocalizations.of(context).translate("thank_you_text"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget paragraphText(String text) {
    return Text(text,
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w500, letterSpacing: 1, color: Colors.black));
  }

  Widget titleText(String text) {
    return Text(text,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500, letterSpacing: 2, color: Colors.black));
  }
}
