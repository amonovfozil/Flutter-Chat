import 'package:flutter/material.dart';
import 'package:flutter_chat/logic/firebase/firebase_controller.dart';
import 'package:flutter_chat/models/user_models.dart';
import 'package:flutter_chat/utils/constants.dart';
import 'package:flutter_chat/widgets/chats/user_card.dart';
import 'package:get/get.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  void initState() {
    FirebaseController.getContact();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<UserModel> contacts = FirebaseController.contacts
          .where((user) => user.id != FirebaseController.me.id)
          .toList();
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Row(
            children: [
              BackButton(),
              SizedBox(width: kDefaultPadding * 0.75),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Contacts",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.person_add_alt_rounded),
              onPressed: () {},
            ),
            const SizedBox(width: kDefaultPadding / 2),
          ],
        ),
        body: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) => UserCard(
            user: contacts[index],
            press: () {
              FirebaseController.creatUserChat(contacts[index]);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: kPrimaryColor,
          child: const Icon(
            Icons.person_add_alt_1,
            color: Colors.white,
          ),
        ),
      );
    });
  }
}
