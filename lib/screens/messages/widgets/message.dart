import 'package:flutter_chat/logic/firebase/firebase_api.dart';
import 'package:flutter_chat/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/messages/message_type/image_message.dart';
import 'package:flutter_chat/screens/messages/message_type/pdf_message.dart';


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

          return Padding(
            padding: const EdgeInsets.only(top: kDefaultPadding / 3),
            child: GestureDetector(
                 onLongPress: () {
                    
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
              
                  messageContaint(message),
                  // if (message.fromId == FirebaseController.me.id)
                  //   MessageStatusDot(status: message.status)
                ],
              ),
            ),
          );
        });
  }
}

class MessageStatusDot extends StatelessWidget {
  final MessageStatus? status;

  const MessageStatusDot({super.key, this.status});
  @override
  Widget build(BuildContext context) {
    Color dotColor(MessageStatus status) {
      switch (status) {
        case MessageStatus.notSent:
          return kErrorColor;
        case MessageStatus.notView:
          return Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.1);
        case MessageStatus.viewed:
          return kPrimaryColor;
        default:
          return Colors.transparent;
      }
    }

    return Container(
      margin: const EdgeInsets.only(left: kDefaultPadding / 2),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: dotColor(status!),
        shape: BoxShape.circle,
      ),
      child: Icon(
        status == MessageStatus.notSent ? Icons.close : Icons.done,
        size: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
