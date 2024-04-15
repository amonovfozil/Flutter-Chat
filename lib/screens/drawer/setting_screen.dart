import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/logic/firebase/firebase_controller.dart';
import 'package:flutter_chat/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    // color: kPrimaryColor,
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
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 50),
                      child: Row(
                        children: [
                          const BackButton(),
                          const SizedBox(width: kDefaultPadding * 0.75),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Settings",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const Spacer(),
                          PopupMenuButton(
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                child: Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.delete,
                                      size: 20,
                                    ),
                                    SizedBox(width: 15),
                                    Text(
                                      "Delete accaunt",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Row(
                        children: [
                          FirebaseController.me.image != null
                              ? CircleAvatar(
                                  radius: 24,
                                  backgroundImage:
                                      AssetImage(FirebaseController.me.image!),
                                )
                              : const Icon(
                                  CupertinoIcons.person_crop_circle,
                                  size: 65,
                                ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kDefaultPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  FirebaseController.me.name,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                // const SizedBox(height: 8),
                                const Opacity(
                                  opacity: 0.64,
                                  child: Text(
                                    "online",
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Opacity(
                                      opacity: 0.9,
                                      child: Text(
                                        "created:  ",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Opacity(
                                      opacity: 0.64,
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
                      backgroundColor: kSecondaryColor,
                      onPressed: () async {
                        openImageDialog();
                      },
                      child: const Icon(Icons.add_a_photo_outlined),
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
        ],
      ),
    );
  }

  Future<void> openImageDialog() async {
    final ImagePicker picker = ImagePicker();
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
