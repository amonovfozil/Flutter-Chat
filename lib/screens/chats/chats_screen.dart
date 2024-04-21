import 'package:flutter_chat/logic/chats/user_controller.dart';
import 'package:flutter_chat/screens/home/home_screen.dart';
import 'package:flutter_chat/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/chat_sc_body.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: buildAppBar(),
        body: const ChatScreenBody(),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: kPrimaryColor,
      automaticallyImplyLeading: false,
      title: Text(selectedIndex.value == 0
          ? "Chats"
          : selectedIndex.value == 1
              ? "People"
              : selectedIndex.value == 2
                  ? "Groups"
                  : "Channels"),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
        ),
      ],
    );
  }
}
