import 'package:flutter/material.dart';
import 'package:flutter_chat/logic/firebase/firebase_controller.dart';
import 'package:flutter_chat/screens/chats/chats_screen.dart';
import 'package:flutter_chat/screens/drawer/setting_screen.dart';
import 'package:flutter_chat/widgets/components/circle_image.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

RxInt _selectedIndex = 0.obs;

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: _selectedIndex.value == 4
            ? const SettingScreen()
            : const ChatsScreen(),
        bottomNavigationBar: buildBottomNavigationBar(),
      ),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex.value,
      onTap: (value) {
        _selectedIndex.value = value;
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
            img: FirebaseController.me.image,
            radius: 40,
          ),
          label: "Profile",
        ),
      ],
    );
  }
}
