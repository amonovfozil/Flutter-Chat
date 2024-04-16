// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat/logic/firebase/firebase_controller.dart';
// import 'package:flutter_chat/screens/drawer/contact_screen.dart';
// import 'package:flutter_chat/screens/drawer/setting_screen.dart';
// import 'package:flutter_chat/utils/constants.dart';
// import 'package:flutter_chat/widgets/components/circle_image.dart';
// import 'package:get/get.dart';

// class DrawerScreen extends StatelessWidget {
//   const DrawerScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Column(
//         children: [
// // user info
//           Container(
//             height: 150,
//             // width: Get.width,
//             // padding: const EdgeInsets.symmetric(horizontal: 10),
//             decoration: const BoxDecoration(
//               color: kPrimaryColor,
//               borderRadius: BorderRadius.only(
//                 bottomRight: Radius.circular(60),
//               ),
//             ),
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 20),
//               child: ListTile(
//                 leading: CircleImage(
//                   img: FirebaseController.me.image,
//                 ),
//                 title: Text(
//                   FirebaseController.me.name.value,
//                   // "Amonov Fozil",
//                   style: const TextStyle(fontSize: 20),
//                 ),
//                 subtitle: Text(
//                   FirebaseController.me.email,
//                 ),
//                 titleAlignment: ListTileTitleAlignment.center,
//               ),
//             ),
//           ),

// // Category  items
//           const SizedBox(height: 30),
//           ListTile(
//             onTap: () {
//               Get.to(() => const ProfileScreen());
//             },
//             leading: const Icon(CupertinoIcons.settings),
//             title: const Text("Setting"),
//             titleAlignment: ListTileTitleAlignment.center,
//           ),
//           ListTile(
//             onTap: () {
//               Get.to(() => const ContactScreen());
//               // Navigator.of(context).push(MaterialPageRoute(
//               //   builder: (context) => ContactScreen(),
//               // ));
//             },
//             leading: const Icon(CupertinoIcons.person_3_fill),
//             title: const Text("Contact"),
//             titleAlignment: ListTileTitleAlignment.center,
//           ),

// // Sign part
//           const Spacer(),
//           Card(
//             color: kSecondaryColor,
//             child: ListTile(
//               splashColor: kPrimaryColor,
//               leading: const Icon(Icons.output),
//               title: const Text("Sign out accaunt"),
//               onTap: () {
//                 FirebaseController.auth.signOut();
//                 FirebaseController.updateActiveStatus(false);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
