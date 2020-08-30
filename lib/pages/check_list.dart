import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pollokratia/models/mission_card.dart';
import 'package:firebase_database/firebase_database.dart';
import '../app_localizations.dart';
import '../globals.dart' as globals;

class CheckListPage extends StatefulWidget {
  @override
  _CheckListPageState createState() => _CheckListPageState();
}

class _CheckListPageState extends State<CheckListPage> with SingleTickerProviderStateMixin {
  List<MissionCard> _missionsList = new List();
  List<MissionCard> _userMissionsList = new List();

  final userId = globals.firebaseUser.uid;
  static const String PUSH_UP = "pushup";
  static const String PUSH_DOWN = "pushdown";

  Tween<Offset> _offset = Tween(begin: Offset(1, -0.3), end: Offset(0, 0));
  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((data) async {
      await getMissionsFromFireBase();
      insertMissionOneByOne();
    });
  }

  void insertMissionOneByOne() {
    Future future = Future(() {});
    int missionIndex = 0;

    _missionsList.forEach((MissionCard card) {
      future = future.then((data) {
        //Future delay for the one by one animation.
        return Future.delayed(const Duration(milliseconds: 500), () {
          _listKey.currentState.insertItem(missionIndex);
          missionIndex++;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("find_missions")),
      ),
      body: Container(
        decoration: BoxDecoration(
          // color: Colors.red,
          image: DecorationImage(image: AssetImage(globals.backgroundColor), fit: BoxFit.cover),
        ),
        child: Center(
          child: _buildUI(context),
        ),
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    return AnimatedList(
        key: _listKey,
        initialItemCount: _missionsList.length,
        itemBuilder: (BuildContext context, int index, animation) {
          return SlideTransition(
              position: animation.drive(_offset), child: cardTemplate(_missionsList[index]));
        });
  }

  Widget cardTemplate(MissionCard card) {
    return Card(
      margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Container(
        padding: EdgeInsets.fromLTRB(3, 12, 3, 6),
        child: Column(
          children: <Widget>[
            firstRow(card),
            secondRow(card),
            thirdRow(card),
            bottomRow(context, card),
          ],
        ),
      ),
    );
  }

  Widget firstRow(MissionCard card) {
    bool checkBoxVal = card.checkBoxValue.toString() == "true" ? true : false;
    var screenWidth = MediaQuery.of(context).size.width;
    return Row(
      children: <Widget>[
        Checkbox(
          value: checkBoxVal,
          onChanged: (bool value) {},
        ),
        Container(
          width: screenWidth - 60,
          child: Text(
            card.title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget secondRow(MissionCard card) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 40,
          height: 30,
        ),
        Container(
            width: MediaQuery.of(context).size.width - 50,
            child: Text(
              card.description,
              style: TextStyle(fontSize: 15),
            )),
      ],
    );
  }

  Widget thirdRow(MissionCard card) {
    bool isPositiveBigger = int.parse(card.positiveVotes) >= int.parse(card.negativeVotes);
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(right: 5),
                child: Icon(
                  Icons.arrow_upward,
                  size: isPositiveBigger ? 25 : 20,
                  color: Color(0xFF5b9ae9),
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 5),
                child: Text(
                  card.positiveVotes,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                padding: EdgeInsets.only(right: 5),
                child: Icon(Icons.arrow_downward,
                    color: Color(0xFF0068e9), size: isPositiveBigger ? 20 : 25),
              ),
              Container(
                padding: EdgeInsets.only(right: 5),
                child: Text(
                  card.negativeVotes,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomRow(BuildContext context, MissionCard card) {
    MissionCard userCard =
        _userMissionsList.firstWhere((element) => element.key == card.key, orElse: () => null);

    return Padding(
      padding: EdgeInsets.all(8),
      child: Table(
        children: [
          TableRow(children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 1,
                      color: Colors.grey[500],
                      blurRadius: 1.0,
                      offset: Offset(0, 1.0))
                ],
                color: Color(0xFF5b9ae9),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.zero,
                    topLeft: Radius.zero),
              ),
              child: FlatButton(
                onPressed: () {
                  _showDialog(card.title, card.forArticleOpinion, 'for', context);
                },
                child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF5b9ae9),
                    ),
                    child: Text(
                      AppLocalizations.of(context).translate("why_yes"),
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
                    )),
              ),
            ),
            Container(
              height: 40,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 1,
                      color: Colors.grey[500],
                      blurRadius: 1.0,
                      offset: Offset(0, 1.0))
                ],
                color: Color(0xFF0068e9),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.zero,
                    topRight: Radius.zero,
                    bottomLeft: Radius.zero,
                    topLeft: Radius.circular(35)),
              ),
              child: FlatButton(
                onPressed: () {
                  _showDialog(card.title, card.againstArticleOpinion, 'against', context);
                },
                child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF0068e9),
                    ),
                    child: Text(
                      AppLocalizations.of(context).translate("why_not"),
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
                    )),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 1,
                      color: Colors.grey[500],
                      blurRadius: 1.0,
                      offset: Offset(0, 1.0))
                ],
                color: userCard != null && userCard.positiveVotes == "1"
                    ? Color(0xFF5b9ae9)
                    : Colors.blueGrey[100],
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(35),
                    topRight: Radius.zero,
                    bottomLeft: Radius.zero,
                    topLeft: Radius.zero),
              ),
              height: 40,
              child: IconButton(
                icon: Icon(Icons.keyboard_arrow_up, size: 25),
                onPressed: () {
                  affectMission(card, context, PUSH_UP);
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 1,
                      color: Colors.grey[500],
                      blurRadius: 1.0,
                      offset: Offset(0, 1.0))
                ],
                color: userCard != null && userCard.negativeVotes == "1"
                    ? Color(0xFF0068e9)
                    : Colors.blueGrey[100],
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.zero,
                    topRight: Radius.zero,
                    bottomLeft: Radius.circular(10),
                    topLeft: Radius.circular(5)),
              ),
              height: 40,
              child: IconButton(
                  onPressed: () => affectMission(card, context, PUSH_DOWN),
                  icon: Icon(Icons.keyboard_arrow_down, size: 25)),
            ),
          ]),
        ],
      ),
    );
  }

  void affectMission(MissionCard missionCard, BuildContext context, String affect) async {
    String userVotesInMission = await isUserHasMissionCard(missionCard);

    if (userVotesInMission == null) {
      addMissionToUser(missionCard, affect);
    } else if (affect == PUSH_UP && userVotesInMission == "1") {
      globals.showAlertDialog(context, AppLocalizations.of(context).translate("cheat_warning"));
      return;
    } else if (affect == PUSH_DOWN && userVotesInMission == "-1") {
      globals.showAlertDialog(context, AppLocalizations.of(context).translate("cheat_warning"));
      return;
    } else {
      deleteMissionFromUserList(missionCard);
      updateUserMissionCard(missionCard, affect);
    }
    updateMissionVotes(missionCard, affect, userVotesInMission);
    //Update UI.
    setState(() {});
  }

  void addMissionToUser(MissionCard missionCard, String affect) {
    final String value = affect == PUSH_UP ? "1" : "-1";
    //Add mission to list as well.
    _userMissionsList.add(new MissionCard(
      key: missionCard.key,
      positiveVotes: affect == PUSH_UP ? "1" : "0",
      negativeVotes: affect == PUSH_DOWN ? "1" : "0",
    ));
    //Add in firebase.
    FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(userId)
        .child("cardsAssociated")
        .child(missionCard.key)
        .child("votes")
        .set(value);
  }

  Future<String> isUserHasMissionCard(MissionCard missionCard) async {
    String res;

    await FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(userId)
        .child("cardsAssociated")
        .child(missionCard.key)
        .once()
        .then((value) {
      if (value.value != null) res = value.value['votes'];
    });
    return res;
  }

  void updateUserMissionCard(MissionCard missionCard, String affect) async {
    //Get current points in the card
    var currentPoints;
    await FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(userId)
        .child("cardsAssociated")
        .child(missionCard.key)
        .child("votes")
        .once()
        .then((DataSnapshot dataSnapshot) => currentPoints = dataSnapshot.value);
    int updatedPoints =
        affect == PUSH_UP ? int.parse(currentPoints) + 1 : int.parse(currentPoints) - 1;

    if (updatedPoints == 0) {
      deleteMissionInUserFirebase(missionCard);
    }
  }

  void deleteMissionInUserFirebase(MissionCard missionCard) {
    FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(userId)
        .child("cardsAssociated")
        .child(missionCard.key)
        .remove();
  }

  void updateMissionVotes(MissionCard missionCard, String affect, String userVotesInMission) {
    bool isPushUp = affect == PUSH_UP;
    int currentPositiveVotes = int.parse(missionCard.positiveVotes);
    int currentNegativeVotes = int.parse(missionCard.negativeVotes);
    int updatedVote = 0;
    bool isUserVote = userVotesInMission == null;
    String child;

    if (isUserVote && isPushUp) {
      updatedVote = currentPositiveVotes + 1;
      child = "positiveVotes";
      missionCard.positiveVotes = updatedVote.toString();
    } else if (isUserVote && !isPushUp) {
      updatedVote = currentNegativeVotes + 1;
      child = "negativeVotes";
      missionCard.negativeVotes = updatedVote.toString();
    } else if (isPushUp) {
      updatedVote = currentNegativeVotes - 1;
      child = "negativeVotes";
      missionCard.negativeVotes = updatedVote.toString();
    } else {
      updatedVote = currentPositiveVotes - 1;
      child = "positiveVotes";
      missionCard.positiveVotes = updatedVote.toString();
    }
    FirebaseDatabase.instance
        .reference()
        .child("Missions")
        .child(missionCard.key)
        .child(child)
        .set(updatedVote.toString());
  }

  Future<void> _showDialog(String title, String text, String against, BuildContext context) {
    String imagePath =
        against == "against" ? 'assets/images/unlike_image.png' : 'assets/images/like_image.png';

    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context).translate("done_lets_go")),
              ),
            ],
            backgroundColor: Colors.grey[200],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Image.asset(imagePath),
                  Text(title),
                  SizedBox(
                    height: 6,
                  ),
                  Text(text),
                ],
              ),
            ),
          );
        });
  }

  void sortMissionsList() {
    _missionsList.sort((MissionCard a, MissionCard b) => b.compareTo(a));
  }

  getMissionsFromFireBase() async {
    await getAllMissions();
    await getUserMissions();
  }

  getAllMissions() async {
    await FirebaseDatabase.instance
        .reference()
        .child("Missions")
        .once()
        .then((DataSnapshot dataSnapshot) {
      var missionsKeys = dataSnapshot.value.keys;
      _missionsList.clear();

      missionsKeys.forEach((key) {
        _missionsList.add(MissionCard().fromJson(dataSnapshot, key));
      });
    }).catchError((error) => log(error.toString()));
  }

  getUserMissions() async {
    await FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(userId)
        .child("cardsAssociated")
        .once()
        .then((DataSnapshot dataSnapshot) {
      var missionsKeys = dataSnapshot.value.keys;
      _userMissionsList.clear();

      missionsKeys.forEach((key) {
        _userMissionsList.add(MissionCard().userMissionCard(dataSnapshot, key));
      });
    }).catchError((error) => log("user has no missions in his list."));
  }

  void deleteMissionFromUserList(MissionCard missionCard) {
    _userMissionsList.removeWhere((element) => element.key == missionCard.key);
  }
}
