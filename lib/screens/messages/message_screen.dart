import 'package:flutter_chat/logic/firebase/firebase_api.dart';
import 'package:flutter_chat/models/chat_models.dart';
import 'package:flutter_chat/models/user_models.dart';
import 'package:flutter_chat/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/utils/helper/my_date_util.dart';
import 'package:flutter_chat/screens/components/circle_image.dart';

import 'widgets/message_sc_body.dart';

class MessagesScreen extends StatelessWidget {
  final ChatModel chat;
  const MessagesScreen({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: MessageScreenBody(chat: chat),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: StreamBuilder(
          stream: FirebaseAPI.streamAllContact(),
          builder: (context, snapshot) {
            UserModel chatUser = chat.users.firstWhere(
                (element) => element.id != FirebaseAPI.me.id);
            if (snapshot.hasData) {
              chatUser = UserModel.fromJson(snapshot.data!.docs
                  .firstWhere((element) =>
                      element.data()["id"] != FirebaseAPI.me.id &&
                      chat.users.any((user) => user.id == element.data()["id"]))
                  .data());
            }
            return Row(
              children: [
                const BackButton(),
                CircleImage(
                  radius: 35,
                  img: chatUser.image,
                ),
                const SizedBox(width: kDefaultPadding * 0.75),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chatUser.name.value,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        chatUser.isOnline
                            ? "online"
                            : MyDateUtil.getLastActiveTime(
                                context: context,
                                lastActive: chatUser.lastActive,
                              ),
                        style: const TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                )
              ],
            );
          }),
      actions: [
        IconButton(
          icon: const Icon(Icons.local_phone),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.videocam),
          onPressed: () {},
        ),
        const SizedBox(width: kDefaultPadding / 2),
      ],
    );
  }
}
