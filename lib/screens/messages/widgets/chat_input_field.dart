import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/logic/chats/file_controller.dart';
import 'package:flutter_chat/logic/firebase/firebase_controller.dart';
import 'package:flutter_chat/models/chat_message.dart';
import 'package:flutter_chat/models/chat_models.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/constants.dart';

class ChatInputField extends StatefulWidget {
  final ChatModel chat;
  const ChatInputField({super.key, required this.chat});

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  TextEditingController textContr = TextEditingController();

  RxBool isWrote = false.obs;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
          vertical: kDefaultPadding / 2,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 32,
              color: const Color(0xFF087949).withOpacity(0.08),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              const Icon(Icons.mic, color: kPrimaryColor),
              const SizedBox(width: kDefaultPadding),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding * 0.75,
                  ),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.sentiment_satisfied_alt_outlined,
                        color: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .color!
                            .withOpacity(0.64),
                      ),
                      const SizedBox(width: kDefaultPadding / 4),
                      Expanded(
                        child: TextField(
                          controller: textContr,
                          decoration: const InputDecoration(
                            hintText: "Type message",
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            isWrote.value = value.isNotEmpty;
                          },
                        ),
                      ),
                      isWrote.value
                          ? IconButton(
                              onPressed: () {
                                if (textContr.text.trim().isNotEmpty) {
                                  FirebaseController.sendMessage(
                                    widget.chat,
                                    MessageType.text,
                                    msg: textContr.text,
                                  );
                                  textContr.clear();
                                  isWrote.value = false;
                                }
                              },
                              icon: const Icon(Icons.send),
                              color: kPrimaryColor,
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    File? file;
                                    FilePickerResult? result =
                                        await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: [
                                        'jpg',
                                        'png',
                                        'jpeg',
                                        "pdf",
                                        "mp3",
                                        "mp4"
                                      ],
                                    );

                                    if (result != null) {
                                      file = File(result.paths.first!);
                                      FileController.uploadChatFile(
                                          widget.chat, file);
                                    }
                                  },
                                  child: Icon(
                                    Icons.attach_file,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color!
                                        .withOpacity(0.64),
                                  ),
                                ),
                                const SizedBox(width: kDefaultPadding / 4),
                                GestureDetector(
                                  onTap: () async {
                                    final ImagePicker picker = ImagePicker();
                                    picker.supportsImageSource(
                                        ImageSource.gallery);
                                    XFile? image;
                                    image = await picker.pickImage(
                                        source: ImageSource.camera);
                                    if (image != null) {
                                      await FileController.uploadChatFile(
                                          widget.chat, File(image.path));
                                      // Get.back();
                                    }
                                  },
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color!
                                        .withOpacity(0.64),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
