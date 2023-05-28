// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? name;
  String? deviceId;

  UserModel({
    this.name,
    this.deviceId,
  });

  UserModel copyWith({
    String? name,
    String? deviceId,
  }) =>
      UserModel(
        name: name ?? this.name,
        deviceId: deviceId ?? this.deviceId,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json["name"],
        deviceId: json["deviceId"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "deviceId": deviceId,
      };
}
