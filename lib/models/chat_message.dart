import 'dart:convert';

enum MessageType { text, audio, image, video }

enum MessageStatus { notSent, notView, viewed }

MessageModels messageFromJson(String str) =>
    MessageModels.fromJson(json.decode(str));

String messageToJson(MessageModels data) => json.encode(data.toJson());

class MessageModels {
  String id;
  String? msg;
  MessageType type;
  MessageStatus status;
  String fromId;
  DateTime sendTime;
  // final bool isSender;

  MessageModels({
    required this.id,
    this.msg = "",
    required this.type,
    required this.status,
    required this.fromId,
    required this.sendTime,
  });

  factory MessageModels.fromJson(Map<String, dynamic> json) => MessageModels(
        id: json["id"],
        msg: json['msg'].toString(),
        status: json['status'],
        type: json['message_type'],
        fromId: json['from_id'].toString(),
        sendTime: json['send_time'],
      );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['msg'] = msg;
    data['status'] = status;
    data['message_type'] = type;
    data['from_id'] = fromId;
    data['send_time'] = sendTime;
    return data;
  }
}

List demeChatMessages = [
  // ChatMessage(
  //   text: "Hi Sajol,",
  //   messageType: ChatMessageType.text,
  //   messageStatus: MessageStatus.viewed,
  //   isSender: false,
  // ),
  // ChatMessage(
  //   text: "Hello, How are you?",
  //   messageType: ChatMessageType.text,
  //   messageStatus: MessageStatus.viewed,
  //   isSender: true,
  // ),
  // ChatMessage(
  //   text: "",
  //   messageType: ChatMessageType.audio,
  //   messageStatus: MessageStatus.viewed,
  //   isSender: false,
  // ),
  // ChatMessage(
  //   text: "",
  //   messageType: ChatMessageType.video,
  //   messageStatus: MessageStatus.viewed,
  //   isSender: true,
  // ),
  // ChatMessage(
  //   text: "Error happend",
  //   messageType: ChatMessageType.text,
  //   messageStatus: MessageStatus.notSent,
  //   isSender: true,
  // ),
  // ChatMessage(
  //   text: "This looks great man!!",
  //   messageType: ChatMessageType.text,
  //   messageStatus: MessageStatus.viewed,
  //   isSender: false,
  // ),
  // ChatMessage(
  //   text: "Glad you like it",
  //   messageType: ChatMessageType.text,
  //   messageStatus: MessageStatus.notView,
  //   isSender: true,
  // ),
];
