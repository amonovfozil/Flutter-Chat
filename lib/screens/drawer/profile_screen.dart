import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/logic/firebase/firebase_controller.dart';
import 'package:flutter_chat/main.dart';
import 'package:flutter_chat/screens/drawer/contact_screen.dart';
import 'package:flutter_chat/utils/constants.dart';
import 'package:flutter_chat/widgets/components/circle_image.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        // key: _scaffoldKey,
        // drawer: const DrawerScreen(),
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          automaticallyImplyLeading: false,
          // leading: IconButton(
          //     onPressed: () {
          //       _scaffoldKey.currentState!.openDrawer();
          //     },
          //     icon: const Icon(
          //       CupertinoIcons.line_horizontal_3,
          //     )),
          title: const Text("Profile"),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseController.auth.signOut();
                FirebaseController.updateActiveStatus(false);
              },
              icon: const Icon(
                Icons.logout,
              ),
            ),
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    onTap: () {
                      FirebaseController.auth.currentUser!.delete();
                    },
                    child: const Row(
                      children: [
                        Icon(
                          CupertinoIcons.delete,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text("Delete accaunt")
                      ],
                    ),
                  )
                ];
              },
            )
          ],
        ),
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      border: Border.all(
                          width: 1,
                          color: kBorderColor,
                          strokeAlign: BorderSide.strokeAlignOutside),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      )),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        child: Row(
                          children: [
                            CircleImage(
                              img: FirebaseController.me.image,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    FirebaseController.me.name.value,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  // const SizedBox(height: 8),
                                  const Opacity(
                                    opacity: 0.8,
                                    child: Text(
                                      "online",
                                      maxLines: 1,
                                      style: TextStyle(fontSize: 12, height: 1),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        "created:  ",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Opacity(
                                        opacity: 0.8,
                                        child: Text(
                                          DateFormat("d.MM.y").format(
                                              DateTime.parse(FirebaseController
                                                  .me.createdAt)),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    bottom: 0,
                    right: 35,
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: FloatingActionButton(
                        backgroundColor: kContentColorDarkTheme,
                        onPressed: () async {
                          openImageDialog();
                        },
                        child: const Icon(
                          Icons.add_a_photo_outlined,
                          color: kBorderColor,
                        ),
                      ),
                    )
                    // Container(
                    //   height: 50,
                    //   width: 50,
                    //   // shape: CircleBorder(),
                    //   decoration: BoxDecoration(
                    //       color: kSecondaryColor,
                    //       borderRadius: BorderRadius.circular(15)),
                    // ),
                    )
              ],
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("   Category"),
                  const SizedBox(height: 15),
                  Card(
                    color: kBorderColor,
                    child: ListTile(
                      onTap: () {
                        Get.to(() => const ContactScreen());
                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (context) => ContactScreen(),
                        // ));
                      },
                      leading: const Icon(Icons.settings),
                      title: const Text("Settings"),
                      titleAlignment: ListTileTitleAlignment.center,
                      trailing: const Icon(CupertinoIcons.forward),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Card(
                    color: kBorderColor,
                    child: ListTile(
                      onTap: () {
                        Get.to(() => const ContactScreen());
                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (context) => ContactScreen(),
                        // ));
                      },
                      leading: const Icon(CupertinoIcons.person_3_fill),
                      title: const Text("Contact"),
                      titleAlignment: ListTileTitleAlignment.center,
                      trailing: const Icon(CupertinoIcons.forward),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Card(
                    color: kBorderColor,
                    child: ListTile(
                      onTap: () {
                        Get.to(() => const ContactScreen());
                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (context) => ContactScreen(),
                        // ));
                      },
                      leading: CupertinoSwitch(
                        value: theme.value == ThemeMode.dark,
                        onChanged: (value) {
                          theme.value =
                              value ? ThemeMode.dark : ThemeMode.light;
                        },
                      ),
                      title: const Text("Dark mode"),
                      titleAlignment: ListTileTitleAlignment.center,
                      trailing: const Icon(CupertinoIcons.forward),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openImageDialog() async {
    final ImagePicker picker = ImagePicker();
    picker.supportsImageSource(ImageSource.gallery);
    XFile? image;
// Pick an image.
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(20),
        // titlePadding: const EdgeInsets.all(20),
        titleTextStyle: const TextStyle(fontSize: 20),
        title: const Center(
          child: Text(
            "Select Category",
          ),
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () async {
                image = await picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  FirebaseController.updateProfilePicture(File(image!.path));
                  Get.back();
                }
              },
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  CupertinoIcons.photo_camera_solid,
                  size: 40,
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  FirebaseController.updateProfilePicture(File(image!.path));
                  Get.back();
                }
              },
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  CupertinoIcons.photo_fill_on_rectangle_fill,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
