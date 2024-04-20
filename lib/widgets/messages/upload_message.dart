import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat/logic/chats/file_controller.dart';
import 'package:flutter_chat/models/chat_message.dart';
import 'package:flutter_chat/utils/constants.dart';
import 'package:flutter_chat/widgets/components/circular_progress.dart';
import 'package:flutter_chat/widgets/components/undownload_file_view.dart';
import 'package:get/get.dart';

class UploadMessage extends StatefulWidget {
  const UploadMessage({super.key});

  @override
  State<UploadMessage> createState() => _UploadMessageState();
}

class _UploadMessageState extends State<UploadMessage> {
  @override
  Widget build(BuildContext context) {
    // upload messages screen
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
          vertical: Platform.isIOS ? 0 : kDefaultPadding / 2),
      child: Obx(() {
        switch (FileController.uploadFileType.value) {
          //  image message
          case MessageType.image:
            return SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.45, // 45% of total width
              child: AspectRatio(
                aspectRatio: 1.6,
                child: Container(
                  height: 60,
                  width: 50,
                  color: Colors.amber,
                  child: UnDownloadFIleView(
                    isVisible: true,
                    isUpload: true,
                    progressIndecator: FileController.uploadIndecator.value,
                  ),
                ),
              ),
            );
          case MessageType.pdf:
            return SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.45, // 45% of total width
              child: AspectRatio(
                aspectRatio: 3.5,
                child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: kBorderColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressWidget(
                            isUpload: true,
                            progressValue: FileController.uploadIndecator.value,
                            widthBorder: 4,
                            iconSize: 18,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "   ${FileController.filename.value}",
                            maxLines: 1,
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    )),
              ),
            );
          // case MessageType.audio:
          //   return AudioMessage(message: message);
          // case MessageType.video:
          //   return const VideoMessage();
          // case MessageType.text:
          //   return Container(
          //     height: 50,
          //     width: 50,
          //     color: Colors.amber,
          //   );
          default:
            return Container(
                // color: Colors.amber,
                // width: MediaQuery.of(context).size.width * 0.45,
                // // 45% of total width
                // child: AspectRatio(aspectRatio: 1.6, child: Container()),
                );
        }
      }),
    );
  }
}
