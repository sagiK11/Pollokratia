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
                  titleText(AppLocalizations.of(context).translate("about_app_title"),context),
                  SizedBox(
                    height: 20,
                  ),
                  paragraphText(AppLocalizations.of(context).translate("terms_of_service"),context),
                  SizedBox(
                    height: 10,
                  ),
                  paragraphText(
                      AppLocalizations.of(context).translate("terms_of_service_text"), context),
                  SizedBox(
                    height: 20,
                  ),
                  paragraphText(AppLocalizations.of(context).translate("privacy_policy"), context),
                  SizedBox(
                    height: 10,
                  ),
                  paragraphText(
                      AppLocalizations.of(context).translate("privacy_policy_text"), context),
                  paragraphText(
                      AppLocalizations.of(context).translate("we_value_your_privacy"), context),
                  SizedBox(
                    height: 20,
                  ),
                  paragraphText(AppLocalizations.of(context).translate("thank_you"), context),
                  SizedBox(
                    height: 10,
                  ),
                  paragraphText(AppLocalizations.of(context).translate("thank_you_text"), context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget paragraphText(String text, BuildContext context) {
    return Text(text,
        style: Theme.of(context).textTheme.bodyText1);
  }

  Widget titleText(String text, BuildContext context) {
    return Text(text,
        style:Theme.of(context).textTheme.headline4);
  }
}
