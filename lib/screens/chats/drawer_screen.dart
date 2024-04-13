import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Drawer(
      child: Scaffold(
        body: const SafeArea(
          child: Column(
            children: [
              ListTile(
                leading: Icon(CupertinoIcons.settings),
                title: Text("Setting"),
                titleAlignment: ListTileTitleAlignment.center,
              ),
            ],
          ),
        ),
        bottomSheet: ListTile(
          leading: const Icon(Icons.output),
          title: const Text("Exit"),
          onTap:() {
            FirebaseAuth.instance.signOut();
            
          },
        ),
      ),
    );
  }
}
