library pollokratia.globals;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_localizations.dart';

FirebaseUser firebaseUser;

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
