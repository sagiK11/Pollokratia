import 'package:flutter/material.dart';


class User  {
  String email;
  String id;
  String firebaseID;
  String cardsAssociated = "cardsAssociated";

  User ({this.email, this.id, this.firebaseID});

  toJson(){
    return {
      "email": email,
      "id": id,
      "firebaseID":firebaseID,
      "cardsAssociated" : cardsAssociated,
    };
  }




}
