import 'package:flutter_chat/logic/chats/file_controller.dart';
import 'package:flutter_chat/logic/firebase/firebase_api.dart';
import 'package:flutter_chat/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/messages/message_type/image_message.dart';
import 'package:flutter_chat/screens/messages/message_type/pdf_message.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';
import '../message_type/audio_message.dart';
import '../message_type/text_message.dart';
import '../message_type/video_message.dart';

class Message extends StatelessWidget {
  const Message({super.key, required this.message});

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    FirebaseAPI.updateMessageReadStatus(message);

    Widget messageContaint(MessageModel message) {
      switch (message.type) {
        case MessageType.text:
          return TextMessage(message: message);
        case MessageType.audio:
          return AudioMessage(message: message);
        case MessageType.video:
          return VideoMessage(
            message: message,
          );
        case MessageType.image:
          return ImageMessage(message: message);
        case MessageType.pdf:
          return PDFMessage(message: message);
        default:
          return const SizedBox();
      }
    }

    return StreamBuilder(
        stream: FirebaseAPI.streamAllContact(),
        builder: (context, snapshot) {
          // UserModel user = FirebaseController.contacts
          //     .lastWhere((element) => element.id == message.fromId);
          // if (snapshot.hasData) {
          //   user = UserModel.fromJson(snapshot.data!.docs
          //       .firstWhere((element) => element.data()["id"] == message.fromId)
          //       .data());
          // }

          return Obx(
            () => Padding(
              padding: const EdgeInsets.only(top: kDefaultPadding / 3),
              child: GestureDetector(
                onLongPress: () {
                  FileController.isSelect.value = true;
                  FileController.selectMessage(message);
                },
                onTap: () {
                  FileController.selectMessage(message);
                },
                child: Row(
                  mainAxisAlignment: message.fromId == FirebaseAPI.me.id
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    // if (message.fromId != FirebaseController.me.id) ...[
                    //   CircleImage(
                    //     radius: 35,
                    //     img: user.image,
                    //   ),
                    //   const SizedBox(width: kDefaultPadding / 2),
                    // ],
                    if (message.fromId != FirebaseAPI.me.id &&
                        FileController.isSelect.value)
                      SelectMessageStatus(
                          isSelect: FileController.selectMessages
                              .any((elm) => elm.id == message.id)),
                    messageContaint(message),
                    if (message.fromId == FirebaseAPI.me.id &&
                        FileController.isSelect.value)
                      SelectMessageStatus(
                          isSelect: FileController.selectMessages
                              .any((elm) => elm.id == message.id))
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class SelectMessageStatus extends StatelessWidget {
  final bool isSelect;

  const SelectMessageStatus({super.key, required this.isSelect});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: kDefaultPadding / 2),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: isSelect ? kPrimaryColor : kSecondaryColor,
        shape: BoxShape.circle,
      ),
      child: isSelect
          ? Icon(
              Icons.done,
              size: 8,
              color: Theme.of(context).scaffoldBackgroundColor,
            )
          : SizedBox(),
    );
  }
}
