import 'dart:developer';

import 'package:flutter_chat/logic/firebase/firebase_controller.dart';
import 'package:flutter_chat/models/chat_models.dart';
import 'package:flutter_chat/utils/constants.dart';
import 'package:flutter_chat/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/messages/upload_message.dart';

import 'chat_input_field.dart';
import 'message.dart';

class MessageScreenBody extends StatelessWidget {
  final ChatModel chat;

  const MessageScreenBody({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
              stream: FirebaseController.getChatMessages(chat.id),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  log("MESSAGE ${snapshot.data!.docs}");
                  log("MESSAGE text ${snapshot.data!.docs.first.data()}");
                  List<MessageModels> messages = List.from(snapshot.data!.docs
                      .map((e) => MessageModels.fromJson(e.data()))
                      .toList());
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) =>
                          Message(message: messages[index]),
                    ),
                  );
                }
                return Container();
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
              child: UploadMessage(),
            ),
          ],
        ),
        ChatInputField(chat: chat),
      ],
    );
  }
}
