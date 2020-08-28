import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MyAccountPage extends StatefulWidget {
  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  FirebaseUser user;
  String userKey;
  String userPoints;
  bool showFirst = true;

  getUserFromFirebase() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    user = await firebaseAuth.currentUser();
    userKey = user.uid;
    await FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(userKey)
        .once()
        .then((DataSnapshot dataSnapshot) =>
            userPoints = dataSnapshot.value['points']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("מצב הנקודות שלי")),
      body: Center(
        child: FutureBuilder(
          future: getUserFromFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return pointsNumber();
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget pointsNumber() {
    String text = getMessageToUser();

    return Center(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('יש לי', style: TextStyle(fontSize: 20),),
                SizedBox(height: 30),
                Text(
                  userPoints,
                  style: TextStyle(fontSize: 100),
                ),
                SizedBox(height: 30),
                Text('נקודות',style: TextStyle(fontSize: 20),),
                SizedBox(height: 25),
                Text(text,style: TextStyle(fontSize: 20),)
              ]),
        ),
      ),
    );
  }

  String getMessageToUser(){
    String text = "";
    int points = int.parse(userPoints);

    if(points == 35){
      text = allPoints();
    }else if(points >= 30){
      text = manyPoints();
    }else if(points >= 20){
      text = mediumAmountPoints();
    }else if(points >= 10){
      text = fewPoints();
    }else if(points >= 1){
      text = veryFewPoints();
    }else{
      text = noPoints();
    }
    return text;


  }
  String allPoints(){
    return "לא ביזבזת כלום!";
  }
  String manyPoints(){
    return "יש לך יותר מדי, לא להתבייש!";
  }
  String mediumAmountPoints(){
    return "יפה, אפשר עוד!";
  }
  String fewPoints(){
    return "אנחנו מתקדמים!";
  }
  String veryFewPoints(){
    return "עוד קצת והנשיא יעניק לך מדליה!";
  }
  String noPoints(){
    return "כל הכבוד! זכית בתואר אישיות משפיעה :)";
  }
}
