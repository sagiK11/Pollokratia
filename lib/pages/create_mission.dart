import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pollokratia/models/mission_card.dart';
import '../globals.dart' as globals;

import '../app_localizations.dart';

class CreateMission extends StatefulWidget {
  @override
  _CreateMissionState createState() => _CreateMissionState();
}

class _CreateMissionState extends State<CreateMission> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _forArticleOpinion = TextEditingController();
  final _againstArticleOpinion = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("create_mission")),
      ),
      body: Container(
        decoration: BoxDecoration(
          // color: Colors.red,
          image: DecorationImage(image: AssetImage(globals.backgroundColor), fit: BoxFit.fill),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, .2),
                            blurRadius: 20.0,
                            offset: Offset(0, 10))
                      ]),
                  margin: EdgeInsets.fromLTRB(8, 12, 8, 6),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: AppLocalizations.of(context).translate("mission_title"),
                        hintStyle: TextStyle(color: Colors.grey[400])),
                  ),
                ),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, .2),
                            blurRadius: 20.0,
                            offset: Offset(0, 10))
                      ]),
                  margin: EdgeInsets.fromLTRB(8, 12, 8, 6),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: TextField(
                    maxLines: 6,
                    controller: _descriptionController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: AppLocalizations.of(context).translate("mission_des"),
                        hintStyle: TextStyle(color: Colors.grey[400])),
                  ),
                ),
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, .2),
                            blurRadius: 20.0,
                            offset: Offset(0, 10))
                      ]),
                  margin: EdgeInsets.fromLTRB(8, 12, 8, 6),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: TextField(
                    maxLines: 20,
                    controller: _forArticleOpinion,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: AppLocalizations.of(context).translate("for_article"),
                        hintStyle: TextStyle(color: Colors.grey[400])),
                  ),
                ),
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, .2),
                            blurRadius: 20.0,
                            offset: Offset(0, 10))
                      ]),
                  margin: EdgeInsets.fromLTRB(8, 12, 8, 6),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: TextField(
                    maxLines: 20,
                    controller: _againstArticleOpinion,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: AppLocalizations.of(context).translate("against_article"),
                        hintStyle: TextStyle(color: Colors.grey[400])),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 150,
                    child: FlatButton(
                      color:Theme.of(context).buttonColor,
                      child: Text(
                        AppLocalizations.of(context).translate("add_mission"),
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () => addMission(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addMission() async {
    FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
    DatabaseReference databaseReference = firebaseDatabase.reference();
    //Create Mission.
    if (invalidInput()) {
      return;
    }
    final id = databaseReference.child("Missions").push().key.toString();
    MissionCard newMission = new MissionCard(
        title: _titleController.text.toString(),
        description: _descriptionController.text.toString(),
        forArticleOpinion: _forArticleOpinion.text.toString(),
        againstArticleOpinion: _againstArticleOpinion.text.toString(),
        positiveVotes: "0",
        negativeVotes: "0",
        checkBoxValue: "false",
        key: id);
    //Get reference to the path we'll add the new mission.
    final ref = databaseReference.child("Missions");
    ref.child(id).set(newMission.toJson());
    _showAlertDialog(context, AppLocalizations.of(context).translate("mission_success"), false);
  }

  bool invalidInput() {
    const MIN_TITLE_LENGTH = 10;
    const MIN_DESCRIPTION_LENGTH = 20;
    const MIN_FOR_ARTICLE_LENGTH = 150;
    const MIN_AGAIN_ARTICLE_LENGTH = 150;

    if (_titleController.text.toString().length < MIN_TITLE_LENGTH) {
      _showAlertDialog(context, AppLocalizations.of(context).translate("title_err"), true);
      return true;
    }
    if (_descriptionController.text.toString().length < MIN_DESCRIPTION_LENGTH) {
      _showAlertDialog(context, AppLocalizations.of(context).translate("des_err"), true);
      return true;
    }
    if (_forArticleOpinion.text.toString().length < MIN_FOR_ARTICLE_LENGTH) {
      _showAlertDialog(context, AppLocalizations.of(context).translate("pro_article_err"), true);
      return true;
    }
    if (_againstArticleOpinion.text.toString().length < MIN_AGAIN_ARTICLE_LENGTH) {
      _showAlertDialog(
          context, AppLocalizations.of(context).translate("against_article_err"), true);
      return true;
    }
    return false;
  }

  Future<void> _showAlertDialog(BuildContext context, String alert, bool error) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [
              FlatButton(
                onPressed: () {
                  if (!error)
                    Navigator.popAndPushNamed(context, '/CheckList');
                  else
                    Navigator.of(context).pop();
                },
                child: Text(error
                    ? AppLocalizations.of(context).translate("mission_error")
                    : AppLocalizations.of(context).translate("lets_see_mission")),
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
