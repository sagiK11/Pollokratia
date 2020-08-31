import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pollokratia/models/user.dart';
import '../app_localizations.dart';
import '../globals.dart' as globals;

class Authentication extends StatelessWidget {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  static const String REGISTER = "register";
  static const String LOGIN = "login";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final String authenticationType;

  Authentication(this.authenticationType);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Positioned(
              child: background(context),
            ),
            Positioned(
              top: 100,
              right: 15,
              left: 15,
              child: title(context),
            ),
            Positioned(
              top: 230,
              right: 15,
              left: 15,
              child: formControl(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget background(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(globals.backgroundColor),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget title(BuildContext context) {
    return Text(
      authenticationType == Authentication.LOGIN
          ? AppLocalizations.of(context).translate("יhello_to_you")
          : AppLocalizations.of(context).translate("have_not_singed"),
      style: Theme.of(context).textTheme.headline1,
    );
  }

  Widget form(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 20.0, offset: Offset(0, 10.0))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: MediaQuery.of(context).size.width - 70,
          child: Column(
            children: <Widget>[
              customTextField(context, _emailController, "email"),
              customTextField(context, _idController, "id"),
              customTextField(context, _passwordController, "password"),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginButton(BuildContext context) {
    return Opacity(
      opacity: authenticationType == Authentication.LOGIN ? 1 : 0,
      child: FlatButton(
        onPressed: () async {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            duration: Duration(seconds: 15),
            content: Row(
              children: <Widget>[
                CircularProgressIndicator(),
                Text(AppLocalizations.of(context).translate("validating"))
              ],
            ),
          ));
          logUser(context).then((isValidUser) {
            if (isValidUser) {
              Navigator.popAndPushNamed(context, '/Home');
            }
          });
        },
        child: Container(
          height: 50,
          child: Center(
              child: Text(
            authenticationType == Authentication.LOGIN
                ? AppLocalizations.of(context).translate("sign_in")
                : AppLocalizations.of(context).translate("sign_up"),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          )),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              radius: 3,
              colors: [Color(0xFF3277cd), Color(0xFF5590c8)],
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 15.0, offset: Offset(0, 0))],
          ),
        ),
      ),
    );
  }

  Widget formControl(BuildContext context) {
    return Column(
      children: <Widget>[
        form(context),
        SizedBox(
          height: 30,
        ),
        loginButton(context),
        SizedBox(
          height: 15,
        ),
        registerButton(context),
      ],
    );
  }

  Widget customTextField(BuildContext context, controller, String hint) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            blurRadius: 1.0,
            offset: Offset(0, -1),
          )
        ],
      ),
      child: TextField(
        obscureText: controller == _passwordController,
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: AppLocalizations.of(context).translate(hint),
          contentPadding: const EdgeInsets.fromLTRB(0, 2, 10, 0),
          hintStyle: Theme.of(context).textTheme.bodyText2,
        ),
      ),
    );
  }

  Future<bool> logUser(BuildContext context) async {
    String email = _emailController.text.toString().trim();
    final id = _idController.text.toString().trim();
    final pass = _passwordController.text.toString().trim();
    try {
      AuthResult result =
          await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);

      FirebaseUser user = result.user;
      globals.firebaseUser = user;
    } catch (err) {
      _showAlertDialog(context, AppLocalizations.of(context).translate("val_err_try_again"));
      _scaffoldKey.currentState.removeCurrentSnackBar();
      return false;
    }
    return true;
  }

  Widget registerButton(BuildContext context) {
    return FlatButton(
      onPressed: () async {
        if (authenticationType == Authentication.LOGIN)
          Navigator.pushNamed(context, '/Register');
        else {
          registerUser().then((registerSuccess) {
            if (registerSuccess) {
              Navigator.pushNamed(context, '/'); //LoginScreen
            } else {
              _showAlertDialog(context, AppLocalizations.of(context).translate("validate_error"));
            }
          });
        }
      },
      child: Container(
        height: 50,
        child: Center(
            child: Text(
          AppLocalizations.of(context).translate("sign_up"),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.blue),
        )),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(blurRadius: 3.0, offset: Offset(0, 0))],
        ),
      ),
    );
  }

  Future<bool> registerUser() async {
    FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
    DatabaseReference databaseReference = firebaseDatabase.reference();
    FirebaseAuth auth = FirebaseAuth.instance;
    final email = _emailController.text.toString().trim();
    final id = _idController.text.toString().trim();
    final pass = _passwordController.text.toString().trim();

    try {
      AuthResult result = await auth.createUserWithEmailAndPassword(email: email, password: pass);

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
                child: Text(AppLocalizations.of(context).translate("alright_i_try_again")),
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
