import 'dart:developer';

import 'package:flutter_chat/logic/firebase/firebase_controller.dart';
import 'package:flutter_chat/screens/components/chat_card.dart';
import 'package:flutter_chat/models/chat_models.dart';
import 'package:flutter_chat/screens/messages/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreenBody extends StatelessWidget {
  const ChatScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Container(
        //   padding: const EdgeInsets.fromLTRB(
        //       kDefaultPadding, 0, kDefaultPadding, kDefaultPadding),
        //   color: kPrimaryColor,
        //   child: Row(
        //     children: [
        //       FillOutlineButton(press: () {}, text: "Recent Message"),
        //       const SizedBox(width: kDefaultPadding),
        //       FillOutlineButton(
        //         press: () {},
        //         text: "Active",
        //         isFilled: false,
        //       ),
        //     ],
        //   ),
        // ),
        Expanded(
          child: StreamBuilder(
              stream: FirebaseController.getAllChats(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.connectionState == ConnectionState.none) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  log("all snapshot data ${snapshot.data!.docs}");
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      List<ChatModel> chatsData = List.from(snapshot.data!.docs
                          .map((data) => ChatModel.fromJson(
                              snapshot.data!.docs[index].data()))
                          .toList());
                      return ChatCard(
                        chat: chatsData[index],
                        press: () {
                          Get.to(
                            () => MessagesScreen(chat: chatsData[index]),
                          );
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const MessagesScreen(),
                          //   ),
                          // );
                        },
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text("IS Emty"),
                  );
                }
              }),
        ),
      ],
    );
  }
}
