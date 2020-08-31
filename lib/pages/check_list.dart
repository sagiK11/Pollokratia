import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pollokratia/widgets/card_template.dart';
import 'package:pollokratia/models/mission_card.dart';
import 'package:firebase_database/firebase_database.dart';
import '../app_localizations.dart';
import '../globals.dart' as globals;

class CheckListPage extends StatefulWidget {
  static const String PUSH_UP = "pushup";
  static const String PUSH_DOWN = "pushdown";

  @override
  _CheckListPageState createState() => _CheckListPageState();
}

class _CheckListPageState extends State<CheckListPage> with SingleTickerProviderStateMixin {
  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  Tween<Offset> _offset = Tween(begin: Offset(0, 1), end: Offset(0, 0));
  List<MissionCard> _missionsList = new List();
  List<MissionCard> _userMissionsList = new List();
  final userId = globals.firebaseUser.uid;


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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).translate("find_missions"),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(globals.backgroundColor), fit: BoxFit.cover),
          ),
          child: Center(
            child: _buildUI(),
          ),
        ),
      ),
    );
  }

  Widget _buildUI() {
    return AnimatedList(
        key: _listKey,
        initialItemCount: _missionsList.length,
        itemBuilder: (BuildContext context, int index, animation) {
          MissionCard currentCard = _missionsList[index];
          return SlideTransition(
              position: animation.drive(_offset),
              child: CardTemplate(
                  missionCard: currentCard,
                  userMissionsList: _userMissionsList,
                  onUpVote: () => affectMission(currentCard, CheckListPage.PUSH_UP),
                  onDownVote: () => affectMission(currentCard, CheckListPage.PUSH_DOWN)));
        });
  }

  void affectMission(MissionCard missionCard, String affect) async {
    String userVotesInMission = await isUserHasMissionCard(missionCard);

    if (userVotesInMission == null) {
      addMissionToUser(missionCard, affect);
    } else if (affect == CheckListPage.PUSH_UP && userVotesInMission == "1") {
      globals.showAlertDialog(context, AppLocalizations.of(context).translate("cheat_warning"));
      return;
    } else if (affect == CheckListPage.PUSH_DOWN && userVotesInMission == "-1") {
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
    final String value = affect == CheckListPage.PUSH_UP ? "1" : "-1";
    //Add mission to list as well.
    _userMissionsList.add(new MissionCard(
      key: missionCard.key,
      positiveVotes: affect == CheckListPage.PUSH_UP ? "1" : "0",
      negativeVotes: affect == CheckListPage.PUSH_DOWN ? "1" : "0",
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
    int updatedPoints = affect == CheckListPage.PUSH_UP
        ? int.parse(currentPoints) + 1
        : int.parse(currentPoints) - 1;

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
    bool isPushUp = affect == CheckListPage.PUSH_UP;
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
