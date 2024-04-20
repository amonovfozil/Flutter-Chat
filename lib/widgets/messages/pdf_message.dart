import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat/logic/chats/file_controller.dart';
import 'package:flutter_chat/logic/firebase/firebase_controller.dart';
import 'package:flutter_chat/models/chat_message.dart';
import 'package:flutter_chat/utils/helper/my_date_util.dart';
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
      width: MediaQuery.of(context).size.width * 0.7, // 45% of total width
      child: AspectRatio(
        aspectRatio: 4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () async {
                if (widget.message.fromId == FirebaseController.me.id) {
                  await OpenFile.open(widget.message.file!.fromAdress);
                } else if ((widget.message.fromId != FirebaseController.me.id &&
                    widget.message.file!.dwnUrl == null)) {
                  FileController.downloadFile(
                      widget.message, downloadIndecator);
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
                        ? Obx(
                            () => Container(
                              height: 35,
                              width: 35,
                              margin: const EdgeInsets.only(left: 5),
                              child: CircularProgressWidget(
                                isUpload: false,
                                progressValue: downloadIndecator.value,
                                widthBorder: 5,
                                iconSize: 20,
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 35,
                            width: 35,
                            child: Image.asset(
                              "assets/images/icon_pdf.png",
                            ),
                          ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.message.file!.name,
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          height: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            MyDateUtil.getFormattedTime(
              context: context,
              message: widget.message,
            ),
          ],
        ),
      ),
    );
  }
}
