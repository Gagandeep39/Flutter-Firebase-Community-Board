import 'package:firebase_database/firebase_database.dart';

///Created on Android Studio Canary Version
///User: Gagandeep
///Date: 05-05-2019
///Time: 21:23
///Project Name: firebase_app

class Board{
  String key;
  String subject;
  String body;

  Board(this.subject, this.body);


  Board.fromSnapshot(DataSnapshot snapshot){
    key = snapshot.key;
    subject = snapshot.value["subject"];
    body = snapshot.value["body"];
  }

  toJson(){
    return {
      "subject" : subject,
      "body" : body,
    };
  }
}

