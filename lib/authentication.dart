import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pollokratia/user.dart';
import 'app_localizations.dart';
import 'globals.dart' as globals;

class Authentication extends StatelessWidget {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  static const String REGISTER = "register";
  static const String LOGIN = "login";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String authenticationType;

  Authentication( this.authenticationType);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/bg_2.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(12, 80, 12, 16),
                    child: Text(
                      authenticationType == Authentication.LOGIN
                          ? AppLocalizations.of(context)
                              .translate("יhello_to_you")
                          : AppLocalizations.of(context)
                              .translate("have_not_singed"),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 220, 20, 0),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[300],
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10.0))
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(width: 0.09)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white,
                                          blurRadius: 2.0,
                                          offset: Offset(0, -2),
                                        )
                                      ],
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: TextField(
                                        controller: _emailController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: AppLocalizations.of(context)
                                              .translate("email"),
                                          hintStyle: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[800]),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(width: 0.09)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white,
                                          blurRadius: 1.0,
                                          offset: Offset(0, -2),
                                        )
                                      ],
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: TextField(
                                        controller: _idController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: AppLocalizations.of(context)
                                              .translate("id"),
                                          hintStyle: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[800]),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(width: 0.20)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white,
                                          blurRadius: 1.0,
                                          offset: Offset(0, -1),
                                        )
                                      ],
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: TextField(
                                        obscureText: true,
                                        controller: _passwordController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: AppLocalizations.of(context)
                                              .translate("password"),
                                          hintStyle: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[800]),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Opacity(
                            opacity: authenticationType == Authentication.LOGIN
                                ? 1
                                : 0,
                            child: FlatButton(
                              onPressed: () async {
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  duration: Duration(seconds: 15),
                                  content: Row(
                                    children: <Widget>[
                                      CircularProgressIndicator(),
                                      Text(AppLocalizations.of(context)
                                          .translate("validating"))
                                    ],
                                  ),
                                ));

                                logUser(context).whenComplete(() =>
                                    Navigator.popAndPushNamed(
                                        context, '/Home'));
                              },
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                child: Center(
                                    child: Text(
                                  authenticationType == Authentication.LOGIN
                                      ? AppLocalizations.of(context)
                                          .translate("sign_in")
                                      : AppLocalizations.of(context)
                                          .translate("sign_up"),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                )),
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    radius: 3,
                                    colors: [
                                      Color(0xFF3277cd),
                                      Color(0xFF5590c8)
                                    ],
//                                    begin: Alignment.topLeft,
//                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 15.0,
                                        offset: Offset(0, 0))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          FlatButton(
                            onPressed: () async {
                              if (authenticationType == Authentication.LOGIN)
                                Navigator.pushNamed(context, '/Register');
                              else {
                                final email =
                                    _emailController.text.toString().trim();
                                final id = _idController.text.toString().trim();
                                final pass =
                                    _passwordController.text.toString().trim();

                                bool registerSuccess =
                                    await registerUser(id, email, pass);

                                if (registerSuccess) {
                                  Navigator.pushNamed(
                                      context, '/'); //LoginScreen
                                } else {
                                  _showAlertDialog(
                                      context,
                                      AppLocalizations.of(context)
                                          .translate("validate_error"));
                                }
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              child: Center(
                                  child: Text(
                                AppLocalizations.of(context)
                                    .translate("sign_up"),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue),
                              )),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 3.0, offset: Offset(0, 0))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> logUser(BuildContext context) async {
    String email = _emailController.text.toString().trim();
    final id = _idController.text.toString().trim();
    final pass = _passwordController.text.toString().trim();
    try {
      AuthResult result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);

      FirebaseUser user = result.user;
      globals.firebaseUser = user;
    } catch (err) {
      _showAlertDialog(
          context, AppLocalizations.of(context).translate("val_err_try_again"));
      _scaffoldKey.currentState.removeCurrentSnackBar();
      return false;
    }
    return true;
  }

  Future<bool> registerUser(String id, String email, String pass) async {
    FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
    DatabaseReference databaseReference = firebaseDatabase.reference();

    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      AuthResult result = await auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      //Push to realtime db
      String firebaseId = result.user.uid;
      User newUser = new User(email: email, id: id, firebaseID: firebaseId);
      databaseReference.child("users").child(firebaseId).set(newUser.toJson());
    } catch (error) {
      print(error);
      return false;
    }
    return true;
  }

  Future<void> _showAlertDialog(BuildContext context, String alert) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context)
                    .translate("alright_i_try_again")),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Text(alert),
          );
        });
  }
}
