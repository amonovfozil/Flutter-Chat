import 'dart:convert';

import 'package:flutter_chat/models/user_models.dart';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

enum ChatType { user, group, channel }

const _statusEnumMap = {
  'ChatType.user': ChatType.user,
  'ChatType.group': ChatType.group,
  'ChatType.channel': ChatType.channel,
};

class ChatModel {
  final String id;
  final String? name;
  final String lastMessage;
  final List<UserModel> users;
  final bool isActive;
  final ChatType type;
  ChatModel({
    required this.id,
    required this.lastMessage,
    required this.users,
    required this.type,
    this.name,
    this.isActive = false,
  });
  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json["id"],
        name: json['name'],
        users:
            List.from(json['users'].map((e) => UserModel.fromJson(e)).toList()),
        type: _statusEnumMap[json["type"]]!,
        isActive: json['is_active'],
        lastMessage: json['last_message'],
      );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['users'] = List.from(users.map((e) => e.toJson()).toList());
    data['is_active'] = isActive;
    data['last_message'] = lastMessage;
    data['type'] = type.toString();

    return data;
  }
}
