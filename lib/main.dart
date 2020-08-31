import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pollokratia/pages/authentication.dart';
import 'package:pollokratia/theme.dart';
import 'app_localizations.dart';
import 'globals.dart' as globals;

import 'package:pollokratia/pages/home.dart';
import 'package:pollokratia/pages/about_app.dart';
import 'package:pollokratia/pages/check_list.dart';
import 'package:pollokratia/pages/idea_details.dart';
import 'package:pollokratia/pages/create_mission.dart';

void main() {
  runApp(PolloKratia());
}

class PolloKratia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //debugPaintSizeEnabled = true;

    lockScreenOrientation();
    setStatusBarColor(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: basicTheme(),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English, no country code
        const Locale('he', ''), // Hebrew, no country code
      ],
      initialRoute: '/Home',
      routes: {
        '/': (context) => Authentication(Authentication.LOGIN),
        '/Home': (context) => HomePage(),
        '/CheckList': (context) => CheckListPage(),
        '/Register': (context) => Authentication(Authentication.REGISTER),
        '/AboutMe': (context) => AboutMe(),
        '/AppIdea': (context) => AppIdea(),
        '/MissionCreation': (context) => CreateMission(),
      },
    );
  }

  void lockScreenOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void setStatusBarColor(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Theme.of(context).primaryColor,
      statusBarIconBrightness: Brightness.light,
    ));
  }
}
