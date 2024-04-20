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
          case MessageType.image || MessageType.video:
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
              width:
                  MediaQuery.of(context).size.width * 0.7, // 45% of total width
              child: AspectRatio(
                aspectRatio: 5,
                child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: kBorderColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 5),
                        SizedBox(
                          height: 35,
                          width: 35,
                          child: CircularProgressWidget(
                            isUpload: true,
                            progressValue: FileController.uploadIndecator.value,
                            widthBorder: 5,
                            iconSize: 20,
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
          case MessageType.audio:
            return Container(
              width: MediaQuery.of(context).size.width * 0.7,
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding * 0.75,
                // vertical: kDefaultPadding / 2.5,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: kBorderColor.withOpacity(0.5),
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
                      iconSize: 15,
                    ),
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: const SliderThemeData(
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 6),
                        trackHeight: 3,
                      ),
                      child: Slider(
                        value: 0,
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                  const Text(
                    "0.37",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            );
          // case MessageType.video:
          //   return const VideoMessage();
          // case MessageType.text:
          //   return Container(
          //     height: 50,
          //     width: 50,
          //     color: Colors.amber,
          //   );
          default:
            return Container();
        }
      }),
    );
  }
}
