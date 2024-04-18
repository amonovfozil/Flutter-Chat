import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat/logic/chats/file_controller.dart';
import 'package:flutter_chat/logic/firebase/firebase_controller.dart';
import 'package:flutter_chat/models/chat_message.dart';
import 'package:flutter_chat/widgets/components/circular_progress.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';

import '../../utils/constants.dart';

class PDFMessage extends StatefulWidget {
  final MessageModels message;
  const PDFMessage({super.key, required this.message});

  @override
  State<PDFMessage> createState() => _PDFMessageState();
}

class _PDFMessageState extends State<PDFMessage> {
  RxDouble downloadIndecator = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45, // 45% of total width
      child: AspectRatio(
        aspectRatio: 3.5,
        child: GestureDetector(
          onTap: () async {
            if (widget.message.fromId != FirebaseController.me.id) {
              await OpenFile.open(widget.message.file!.fromAdress);
            } else if ((widget.message.fromId != FirebaseController.me.id &&
                widget.message.file!.dwnUrl == null)) {
              FileController.downloadFile(widget.message, downloadIndecator);
            } else {
              await OpenFile.open(widget.message.file!.dwnUrl);
            }
          },
          child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kBorderColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  (widget.message.fromId != FirebaseController.me.id &&
                          widget.message.file!.dwnUrl == null)
                      ? SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressWidget(
                            isUpload: false,
                            progressValue: downloadIndecator.value,
                            widthBorder: 4,
                            iconSize: 18,
                          ),
                        )
                      : Image.asset("assets/images/icon_pdf.png"),
                  Expanded(
                    child: Text(
                      "  ${widget.message.file!.name}",
                      maxLines: 1,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
