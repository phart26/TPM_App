// To parse this JSON data, do
//
//     final fetchToken = fetchTokenFromJson(jsonString);

import 'dart:convert';

FetchToken fetchTokenFromJson(String str) =>
    FetchToken.fromJson(json.decode(str));

String fetchTokenToJson(FetchToken data) => json.encode(data.toJson());

class FetchToken {
  FetchToken({
    this.userId,
    this.userName,
    this.token,
  });

  String userId;
  String userName;
  String token;

  factory FetchToken.fromJson(Map<String, dynamic> json) => FetchToken(
        userId: json["userID"],
        userName: json["userName"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "userID": userId,
        "userName": userName,
        "token": token,
      };
}
