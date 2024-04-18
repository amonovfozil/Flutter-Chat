import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { text, audio, image, video, pdf }

const _statusTypeMap = {
  'MessageType.text': MessageType.text,
  'MessageType.audio': MessageType.audio,
  'MessageType.image': MessageType.image,
  'MessageType.video': MessageType.video,
  'MessageType.pdf': MessageType.pdf,
};

enum MessageStatus { notSent, notView, viewed }

const _statusMap = {
  'MessageStatus.notSent': MessageStatus.notSent,
  'MessageStatus.notView': MessageStatus.notView,
  'MessageStatus.viewed': MessageStatus.viewed,
};

MessageModels messageFromJson(String str) =>
    MessageModels.fromJson(json.decode(str));

String messageToJson(MessageModels data) => json.encode(data.toJson());

class MessageModels {
  String id;
  String chatId;
  String? msg;
  FileModel? file;
  MessageType type;
  MessageStatus status;
  String fromId;
  Timestamp sendTime;
  // final bool isSender;

  MessageModels({
    required this.id,
    required this.chatId,
    this.msg = "",
    this.file,
    required this.type,
    required this.status,
    required this.fromId,
    required this.sendTime,
  });

  factory MessageModels.fromJson(Map<String, dynamic> json) => MessageModels(
        id: json["id"],
        chatId: json["chat_id"],
        msg: json['msg'].toString(),
        file: json['file'] == null ? null : FileModel.fromJson(json['file']),
        status: _statusMap[json['status']]!,
        type: _statusTypeMap[json['message_type']]!,
        fromId: json['from_id'].toString(),
        sendTime: json['send_time'],
      );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['chat_id'] = chatId;
    data['msg'] = msg;
    data['file'] = file?.toJson();
    data['status'] = status.toString();
    data['message_type'] = type.toString();
    data['from_id'] = fromId;
    data['send_time'] = sendTime;
    return data;
  }
}

FileModel fileModelFromJson(String str) => FileModel.fromJson(json.decode(str));

String fileModelToJson(FileModel data) => json.encode(data.toJson());

class FileModel {
  String name;
  String url;
  String? fromAdress;
  String? dwnUrl;
  String? artistName;
  String? duration;

  FileModel({
    required this.name,
    required this.url,
    this.fromAdress,
    this.dwnUrl,
    this.artistName,
    this.duration,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) => FileModel(
        name: json["file_name"],
        url: json['file_url'],
        fromAdress: json['from_adress'],
        dwnUrl: json['download_url'],
        artistName: json['artist_name'],
        duration: json['duration'],
      );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['file_name'] = name;
    data['file_url'] = url;
    data['from_adress'] = fromAdress;
    data['download_url'] = dwnUrl;
    data['artist_name'] = artistName;
    data['duration'] = duration;

    return data;
  }
}
