import 'package:flutter_chat/logic/firebase/firebase_controller.dart';
import 'package:flutter_chat/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/utils/helper/my_date_util.dart';

import '../../utils/constants.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({super.key, this.message});

  final MessageModels? message;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding * 0.8,
          vertical: kDefaultPadding / 2,
        ),
        decoration: BoxDecoration(
          color: kPrimaryColor.withOpacity(
              message?.fromId == FirebaseController.me.id ? 1 : 0.1),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(25),
            topRight: const Radius.circular(25),
            bottomLeft: Radius.circular(
                message?.fromId == FirebaseController.me.id ? 25 : 0),
            bottomRight: Radius.circular(
                message?.fromId == FirebaseController.me.id ? 0 : 25),
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Text(
              "${message!.msg!}               ",
              style: TextStyle(
                height: 1.4,
                color: message?.fromId == FirebaseController.me.id
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
            MyDateUtil.getFormattedTime(
              context: context,
              message: message!,
            ),
          ],
        ));
  }
}
