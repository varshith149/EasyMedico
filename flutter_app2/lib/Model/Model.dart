/*class CounterViewModel {
  int counter = 0;

  CounterViewModel(this.counter);
}*/

// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String ID;
  String EMAIL_ID;
  String RESPONSE_CODE;
  String RESPONSE_MESSAGE;

  UserModel({
    this.ID,
    this.EMAIL_ID,
    this.RESPONSE_CODE,
    this.RESPONSE_MESSAGE,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    ID: json["ID"],
    EMAIL_ID: json["EMAIL_ID"],
    RESPONSE_CODE: json["RESPONSE_CODE"],
    RESPONSE_MESSAGE:  json["RESPONSE_MESSAGE"],
    //createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "ID": ID,
    "EMAIL_ID": EMAIL_ID,
    "RESPONSE_CODE": RESPONSE_CODE,
    "RESPONSE_MESSAGE" : RESPONSE_MESSAGE,
    //"createdAt": createdAt.toIso8601String(),
  };
}

/*
class Iuser {
  String StoreName;
  String Password;

  Iuser({this.StoreName,this.Password});
}
*/


