import 'dart:convert';

import 'package:get/get.dart';

UserModel userModelsFromJson(String str) =>
    UserModel.fromJson(json.decode(str));

String userModelsToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String id;
  RxString name;
  RxString image;
  String email;
  String password;
  String createdAt;
  bool isOnline;
  String lastActive;
  String pushToken;
  // final bool isSender;

  UserModel({
    required this.id,
    required this.name,
    required this.image,
    required this.email,
    required this.password,
    required this.createdAt,
    required this.isOnline,
    required this.lastActive,
    required this.pushToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json['name'].toString().obs,
        image: json['image'].toString().obs,
        email: json['mail'],
        password: json['password'].toString(),
        createdAt: json['created_at'],
        isOnline: json['is_online'],
        lastActive: json['last_active'],
        pushToken: json['push_token'],
      );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name.value;
    data['image'] = image.value;
    data['mail'] = email;
    data['password'] = password;
    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    data['last_active'] = lastActive;
    data['push_token'] = pushToken;
    return data;
  }
}
