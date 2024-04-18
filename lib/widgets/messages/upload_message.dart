import 'package:flutter/material.dart';
import 'package:flutter_chat/logic/chats/file_controller.dart';
import 'package:flutter_chat/models/chat_message.dart';
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
    return Obx(() {
      switch (FileController.uploadFileType.value) {
        case MessageType.image:
          return Visibility(
            visible: FileController.uploadFileType.value != MessageType.text,
            child: SizedBox(
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
                    progressIndecator: FileController.downloadIndecator.value,
                  ),
                ),
              ),
            ),
          );
        // case MessageType.audio:
        //   return AudioMessage(message: message);
        // case MessageType.video:
        //   return const VideoMessage();
        // case MessageType.image:
        //   return ImageMessage(message: message);
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
    });
  }
}
