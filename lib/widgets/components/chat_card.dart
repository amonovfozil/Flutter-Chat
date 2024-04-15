import 'package:flutter/cupertino.dart';
import 'package:flutter_chat/logic/firebase/firebase_controller.dart';
import 'package:flutter_chat/models/chat_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/models/user_models.dart';
import 'package:flutter_chat/utils/helper/my_date_util.dart';

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
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.75),
        child: Row(
          children: [
            Stack(
              children: [
                chatUser.image != null
                    ? CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage(chatUser.image!),
                      )
                    : const Icon(
                        CupertinoIcons.person_crop_circle,
                        size: 65,
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
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 3),
                      ),
                    ),
                  )
              ],
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.name ?? chatUser.name,
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
      ),
    );
  }
}
