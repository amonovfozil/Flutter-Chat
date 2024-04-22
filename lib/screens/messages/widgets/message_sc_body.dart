import 'package:flutter_chat/logic/firebase/firebase_api.dart';
import 'package:flutter_chat/models/chat_models.dart';
import 'package:flutter_chat/utils/constants.dart';
import 'package:flutter_chat/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/utils/helper/my_date_util.dart';
import 'package:flutter_chat/screens/messages/widgets/upload_message.dart';
import 'package:grouped_list/grouped_list.dart';

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
          child: Builder(builder: (context) {
            return StreamBuilder(
                stream: FirebaseAPI.getChatMessages(chat.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    List<MessageModel> messages = List.from(snapshot.data!.docs
                        .map((e) => MessageModel.fromJson(e.data()))
                        .toList());
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      child: GroupedListView(
                        shrinkWrap: true,
                        reverse: true,
                        elements: messages,
                        groupBy: (element) =>
                            DateTime.fromMillisecondsSinceEpoch(
                          element.sendTime.millisecondsSinceEpoch,
                        ).toIso8601String().substring(0, 10),
                        floatingHeader: true,
                        // sort: true,
                        order: GroupedListOrder.DESC,
                        groupSeparatorBuilder: (String groupByValue) =>
                            Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          alignment: Alignment.center,
                          child: Text(
                            MyDateUtil.getFormattedDay(groupByValue),
                          ),
                        ),

                        indexedItemBuilder:
                            (context, MessageModel element, int index) {
                          return Message(message: messages[index]);
                        },
                      ),
                    );
                  }
                  return Container();
                });
          }),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            UploadMessage(),
          ],
        ),
        ChatInputField(chat: chat),
      ],
    );
  }
}
