import 'package:flutter_chat/logic/firebase/firebase_controller.dart';
import 'package:flutter_chat/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/models/user_models.dart';
import 'package:flutter_chat/widgets/messages/image_message.dart';

import '../../utils/constants.dart';
import 'audio_message.dart';
import 'text_message.dart';
import 'video_message.dart';

class Message extends StatelessWidget {
  const Message({
    super.key,
    required this.message,
  });

  final MessageModels message;

  @override
  Widget build(BuildContext context) {
    Widget messageContaint(MessageModels message) {
      switch (message.type) {
        case MessageType.text:
          return TextMessage(message: message);
        case MessageType.audio:
          return AudioMessage(message: message);
        case MessageType.video:
          return const VideoMessage();
        case MessageType.image:
          return ImageMessage(
            message: message,
          );
        case MessageType.pdf:
          return ImageMessage(
            message: message,
          );
        default:
          return const SizedBox();
      }
    }

    return StreamBuilder(
        stream: FirebaseController.streamAllContact(),
        builder: (context, snapshot) {
          UserModel user = FirebaseController.contacts
              .lastWhere((element) => element.id == message.fromId);
          if (snapshot.hasData) {
            user = UserModel.fromJson(snapshot.data!.docs
                .firstWhere((element) => element.data()["id"] == message.fromId)
                .data());
          }

          return Padding(
            padding: const EdgeInsets.only(top: kDefaultPadding),
            child: Row(
              mainAxisAlignment: message.fromId == FirebaseController.me.id
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
