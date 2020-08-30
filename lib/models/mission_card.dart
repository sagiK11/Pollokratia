import 'package:firebase_database/firebase_database.dart';

class MissionCard {
  String title;
  String description;
  String key;
  String forArticleOpinion;
  String againstArticleOpinion;
  String positiveVotes;
  String negativeVotes;
  String checkBoxValue;

  MissionCard(
      {this.title,
      this.description,
      this.forArticleOpinion,
      this.againstArticleOpinion,
      this.positiveVotes,
      this.negativeVotes,
      this.checkBoxValue,
      this.key});

  MissionCard.fromSnapShot(DataSnapshot snapshot) {
    key = snapshot.key;
    title = snapshot.value['title'];
    description = snapshot.value['description'];
    positiveVotes = snapshot.value['positiveVotes'];
    negativeVotes = snapshot.value['negativeVotes'];
    checkBoxValue = snapshot.value['checkBoxValue'];
    forArticleOpinion = snapshot.value['forArticleOpinion'];
    againstArticleOpinion = snapshot.value['againstArticleOpinion'];
  }

  toJson() {
    return {
      "title": title,
      "description": description,
      "forArticleOpinion": forArticleOpinion,
      "positiveVotes": positiveVotes,
      "negativeVotes": negativeVotes,
      "checkBoxValue": checkBoxValue,
      "againstArticleOpinion": againstArticleOpinion,
      "key": key,
    };
  }

  fromJson(DataSnapshot dataSnapshot, String key) {
    var mission = dataSnapshot.value;
    return MissionCard(
        title: mission[key]['title'],
        description: mission[key]['description'],
        forArticleOpinion: mission[key]['forArticleOpinion'],
        againstArticleOpinion: mission[key]['againstArticleOpinion'],
        positiveVotes: mission[key]['positiveVotes'],
        negativeVotes: mission[key]['negativeVotes'],
        checkBoxValue: mission[key]['checkBoxValue'],
        key: mission[key]['key']);
  }

  userMissionCard(DataSnapshot dataSnapshot, String key) {
    var votes = dataSnapshot.value;

    String userVoted = votes[key]['votes'];
    return MissionCard(
      key: key,
      positiveVotes: userVoted == "1" ? "1" : "0",
      negativeVotes: userVoted == "1" ? "0" : "1",
    );
  }

  int compareTo(MissionCard b) {
    if (int.parse(positiveVotes) > int.parse(b.positiveVotes))
      return 1;
    else if (int.parse(positiveVotes) < int.parse(b.positiveVotes)) return -1;
    return 0;
  }

  String toString() {
    return "key = $key\n positiveVote = $positiveVotes\n negativeVotes = $negativeVotes";
  }
}
