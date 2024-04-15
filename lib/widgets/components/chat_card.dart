import 'package:flutter_chat/logic/firebase/firebase_controller.dart';
import 'package:flutter_chat/models/chat_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/models/user_models.dart';
import 'package:flutter_chat/utils/helper/my_date_util.dart';
import 'package:flutter_chat/widgets/components/circle_image.dart';

import '../../utils/constants.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
    required this.chat,
    required this.press,
  });

  final ChatModel chat;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    UserModel chatUser = chat.users
        .firstWhere((element) => element.id != FirebaseController.me.id);
    return InkWell(
      onTap: press,
      child: StreamBuilder(
          stream: FirebaseController.streamAllContact(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              chatUser = UserModel.fromJson(snapshot.data!.docs
                  .firstWhere((element) =>
                      element.data()["id"] != FirebaseController.me.id &&
                      chat.users.any((user) => user.id == element.data()["id"]))
                  .data());
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding,
                    vertical: kDefaultPadding * 0.75),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleImage(
                          img: chatUser.image,
                        ),
                        if (chatUser.isOnline)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              height: 16,
                              width: 16,
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    width: 3),
                              ),
                            ),
                          )
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chat.name ?? chatUser.name.value,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 8),
                            Opacity(
                              opacity: 0.64,
                              child: Text(
                                chat.lastMessage,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        MyDateUtil.getLastActiveTime(
                          context: context,
                          lastActive: chatUser.lastActive,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container();
          }),
    );
  }
}
