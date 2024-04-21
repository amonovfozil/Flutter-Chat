import 'package:flutter/material.dart';
import 'package:flutter_chat/logic/chats/file_controller.dart';
import 'package:flutter_chat/logic/firebase/firebase_controller.dart';
import 'package:flutter_chat/models/chat_message.dart';
import 'package:flutter_chat/utils/helper/my_date_util.dart';
import 'package:flutter_chat/screens/components/undownload_file_view.dart';
import 'package:flutter_chat/screens/messages/widgets/play_video_screen.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';

class VideoMessage extends StatefulWidget {
  final MessageModels message;

  const VideoMessage({super.key, required this.message});

  @override
  State<VideoMessage> createState() => _VideoMessageState();
}

class _VideoMessageState extends State<VideoMessage> {
  RxDouble downloadIndecator = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          if (FileController.getMessageFileUrl(widget.message)
              .startsWith("https://")) {
            FileController.downloadFile(widget.message, downloadIndecator);
          } else {
            Get.dialog(
              PlayVideoScreen(message: widget.message),
            );
          }
        },
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.45, // 45% of total width
              child: AspectRatio(
                aspectRatio: 1.6,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset("assets/images/Video Place Here.png"),
                    ),
                    Container(
                      height: 25,
                      width: 25,
                      decoration: const BoxDecoration(
                        color: kPrimaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                    UnDownloadFIleView(
                      isUpload: false,
                      isVisible:
                          (widget.message.fromId != FirebaseController.me.id &&
                              widget.message.file!.dwnUrl == null),
                      progressIndecator: downloadIndecator.value,
                    ),
                    Positioned(
                      bottom: 2.5,
                      right: 2.5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 3),
                        child: MyDateUtil.getFormattedTime(
                          context: context,
                          message: widget.message,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
