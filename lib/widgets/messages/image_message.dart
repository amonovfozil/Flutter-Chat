import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat/logic/chats/file_controller.dart';
import 'package:flutter_chat/logic/firebase/firebase_controller.dart';
import 'package:flutter_chat/models/chat_message.dart';
import 'package:flutter_chat/widgets/components/undownload_file_view.dart';
import 'package:get/get.dart';

class ImageMessage extends StatefulWidget {
  final MessageModels message;
  const ImageMessage({super.key, required this.message});

  @override
  State<ImageMessage> createState() => _ImageMessageState();
}

class _ImageMessageState extends State<ImageMessage> {
  RxDouble downloadIndecator = 0.0.obs;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          if (widget.message.fromId != FirebaseController.me.id &&
              widget.message.file!.dwnUrl == null) {
            FileController.downloadFile(widget.message, downloadIndecator);
          }
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.45, // 45% of total width
          child: AspectRatio(
            aspectRatio: 1.6,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: (FileController.getMessageFileUrl(widget.message)
                          .startsWith("https://"))
                      ? FadeInImage(
                          image: NetworkImage(
                            widget.message.file!.url,
                            scale: 1.0,
                          ),
                          placeholder: const AssetImage(
                              "assets/images/Video Place Here.png"),
                          imageErrorBuilder: (context, error, stackTrace) =>
                              const ImageIcon(
                                  AssetImage("assets/images/user_icon.png")),
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          width: Get.width,
                          File(
                              FileController.getMessageFileUrl(widget.message)),
                          fit: BoxFit.cover,
                        ),
                ),
                UnDownloadFIleView(
                  isUpload: false,
                  isVisible:
                      (widget.message.fromId != FirebaseController.me.id &&
                          widget.message.file!.dwnUrl == null),
                  progressIndecator: downloadIndecator.value,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
