import 'package:flutter/cupertino.dart';
import 'package:flutter_chat/logic/chats/file_controller.dart';
import 'package:flutter_chat/logic/firebase/firebase_api.dart';
import 'package:flutter_chat/models/chat_models.dart';
import 'package:flutter_chat/utils/constants.dart';
import 'package:flutter_chat/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/utils/helper/my_date_util.dart';
import 'package:flutter_chat/screens/messages/widgets/upload_message.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';

import 'chat_input_field.dart';
import 'message.dart';

List<MessageModel> messages = <MessageModel>[];

class MessageScreenBody extends StatefulWidget {
  final ChatModel chat;

  const MessageScreenBody({super.key, required this.chat});

  @override
  State<MessageScreenBody> createState() => _MessageScreenBodyState();
}

class _MessageScreenBodyState extends State<MessageScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BarForSelectItems(),
        Expanded(
          child: Builder(builder: (context) {
            return StreamBuilder(
                stream: FirebaseAPI.getChatMessages(widget.chat.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    messages = List.from(snapshot.data!.docs
                        .map((e) => MessageModel.fromJson(e.data()))
                        .toList());
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding / 2),
                      child: GroupedListView(
                        shrinkWrap: false,
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
        ChatInputField(chat: widget.chat),
      ],
    );
  }
}

class BarForSelectItems extends StatelessWidget {
  const BarForSelectItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: FileController.isSelect.value,
        child: Container(
          height: 50,
          width: Get.width,
          color: kWarninngColor.withOpacity(0.7),
          child: Row(
            children: [
              CupertinoCheckbox(
                value: FileController.selectMessages == messages,
                activeColor: kPrimaryColor,
                inactiveColor: kBorderColor,
                onChanged: (value) {
                  if (value!) {
                    FileController.selectMessages.value = messages;
                  } else {
                    FileController.selectMessages.clear();
                    // FileController.isSelect.value = false;
                  }
                },
              ),
              Text("all select items"),
              const Spacer(),
              IconButton(
                style: const ButtonStyle(
                  tapTargetSize:
                      MaterialTapTargetSize.shrinkWrap, // the '2023' part
                ),
                onPressed: () {},
                icon: Icon(
                  Icons.drive_file_rename_outline_sharp,
                ),
                iconSize: 22,
              ),
              IconButton(
                style: const ButtonStyle(
                  tapTargetSize:
                      MaterialTapTargetSize.shrinkWrap, // the '2023' part
                ),
                onPressed: () {},
                icon: Icon(
                  CupertinoIcons.delete,
                ),
                iconSize: 20,
              ),
              IconButton(
                style: const ButtonStyle(
                  tapTargetSize:
                      MaterialTapTargetSize.shrinkWrap, // the '2023' part
                ),
                onPressed: () {},
                icon: Icon(
                  CupertinoIcons.arrow_turn_up_right,
                ),
                iconSize: 22,
              ),
              IconButton(
                style: const ButtonStyle(
                  tapTargetSize:
                      MaterialTapTargetSize.shrinkWrap, // the '2023' part
                ),
                onPressed: () {
                  FileController.selectMessages.clear();
                  FileController.isSelect.value = false;
                },
                icon: Icon(
                  Icons.close,
                  color: kErrorColor.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
