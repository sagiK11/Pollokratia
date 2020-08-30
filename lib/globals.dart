library pollokratia.globals;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_localizations.dart';

FirebaseUser firebaseUser;
Color mainColor = Color(0xFF3277cd);
Color secondaryColor = Color(0xFF5590c8);
Color softColor = Color(0xFFc4daf5);
Color softWhite = Color(0xFFfdfdfd);

String backgroundColor = 'assets/images/app_background.png';

//General alert message.
Future<void> showAlertDialog(BuildContext context, String alert) {
  return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: [
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context).translate("only_checking")),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Text(alert),
        );
      });
}
