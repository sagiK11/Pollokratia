import 'package:flutter/material.dart';
import '../app_localizations.dart';
import '../models/mission_card.dart';

class CardTemplate extends StatefulWidget {
  final MissionCard missionCard;
  final List<MissionCard> userMissionsList;
  final VoidCallback onUpVote;
  final VoidCallback onDownVote;

  CardTemplate(
      {Key key,
      @required this.missionCard,
      @required this.userMissionsList,
      @required this.onUpVote,
      @required this.onDownVote})
      : super(key: key);

  @override
  _CardTemplateState createState() => _CardTemplateState();
}

class _CardTemplateState extends State<CardTemplate> {
  MissionCard missionCard;
  List<MissionCard> userMissionsList;

  @override
  void initState() {
    super.initState();
    missionCard = widget.missionCard;
    userMissionsList = widget.userMissionsList;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0.5),
      child: Container(
        padding: const EdgeInsets.fromLTRB(2, 18, 2, 18),
        child: Column(
          children: <Widget>[
            firstRow(),
            secondRow(),
            thirdRow(),
            bottomRow(),
          ],
        ),
      ),
    );
  }

  Widget firstRow() {
    bool checkBoxVal = missionCard.checkBoxValue.toString() == "true" ? true : false;
    return Row(
      children: <Widget>[
        Checkbox(
          value: checkBoxVal,
          onChanged: (bool value) {},
        ),
        Expanded(
          child: Text(
            missionCard.title,
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      ],
    );
  }

  Widget secondRow() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 40,
          height: 30,
        ),
        Expanded(
          child: Text(
            missionCard.description,
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
      ],
    );
  }

  Widget thirdRow() {
    bool isPositiveBigger =
        int.parse(missionCard.positiveVotes) >= int.parse(missionCard.negativeVotes);
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
                  color: Theme.of(context).accentColor,
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 5),
                child: Text(
                  missionCard.positiveVotes,
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
                    color: Theme.of(context).primaryColor, size: isPositiveBigger ? 20 : 25),
              ),
              Container(
                padding: EdgeInsets.only(right: 5),
                child: Text(
                  missionCard.negativeVotes,
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

  Widget bottomRow() {
    MissionCard userCard = userMissionsList.firstWhere((element) => element.key == missionCard.key,
        orElse: () => null);

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
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.zero,
                    topLeft: Radius.zero),
              ),
              child: FlatButton(
                onPressed: () {
                  _showDialog(missionCard.title, missionCard.forArticleOpinion, 'for', context);
                },
                child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
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
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.zero,
                    topRight: Radius.zero,
                    bottomLeft: Radius.zero,
                    topLeft: Radius.circular(35)),
              ),
              child: FlatButton(
                onPressed: () {
                  _showDialog(
                      missionCard.title, missionCard.againstArticleOpinion, 'against', context);
                },
                child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
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
                    ? Theme.of(context).buttonColor
                    : Colors.blueGrey[100],
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(35),
                    topRight: Radius.zero,
                    bottomLeft: Radius.zero,
                    topLeft: Radius.zero),
              ),
              height: 38,
              child: IconButton(
                  icon: Icon(Icons.keyboard_arrow_up, size: 25), onPressed: widget.onUpVote),
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
                    ? Theme.of(context).buttonColor
                    : Colors.blueGrey[100],
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.zero,
                    topRight: Radius.zero,
                    bottomLeft: Radius.circular(10),
                    topLeft: Radius.circular(5)),
              ),
              height: 38,
              child: IconButton(
                  onPressed: widget.onDownVote, icon: Icon(Icons.keyboard_arrow_down, size: 25)),
            ),
          ]),
        ],
      ),
    );
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
}
