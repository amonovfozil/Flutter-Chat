import 'package:flutter/material.dart';
import 'package:flutter_chat/logic/firebase/firebase_api.dart';
import 'package:flutter_chat/screens/chats/chats_screen.dart';
import 'package:flutter_chat/screens/drawer/profile_screen.dart';
import 'package:flutter_chat/screens/components/circle_image.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

RxInt selectedIndex = 0.obs;

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: selectedIndex.value == 4
            ? const ProfileScreen()
            : const ChatsScreen(),
        bottomNavigationBar: buildBottomNavigationBar(),
      ),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex.value,
      onTap: (value) {
        selectedIndex.value = value;
      },
      items: [
        const BottomNavigationBarItem(
            icon: Icon(Icons.messenger), label: "Chats"),
        const BottomNavigationBarItem(
            icon: Icon(Icons.person), label: "People"),
        const BottomNavigationBarItem(
            icon: Icon(Icons.people), label: "Groups"),
        const BottomNavigationBarItem(
            icon: Icon(Icons.bookmarks_rounded), label: "Channels"),
        BottomNavigationBarItem(
          icon: CircleImage(
            img: FirebaseAPI.me.image,
            radius: 40,
          ),
          label: "Profile",
        ),
      ],
    );
  }
}
