import 'package:flutter_chat/logic/chats/file_controller.dart';
import 'package:flutter_chat/logic/firebase/firebase_controller.dart';
import 'package:flutter_chat/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/components/circular_progress.dart';
import 'package:get/get.dart';
// import 'package:just_audio/just_audio.dart';

import '../../utils/constants.dart';

class AudioMessage extends StatefulWidget {
  final MessageModels message;

  const AudioMessage({super.key, required this.message});

  @override
  State<AudioMessage> createState() => _AudioMessageState();
}

class _AudioMessageState extends State<AudioMessage> {
  FileController playController = Get.put(FileController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.55,
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding * 0.75,
        vertical: kDefaultPadding / 2.5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: kPrimaryColor.withOpacity(
            widget.message.fromId == FirebaseController.me.id ? 1 : 0.1),
      ),
      child: Row(
        children: [
          (widget.message.fromId != FirebaseController.me.id &&
                  widget.message.file!.dwnUrl == null)
              ? const SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressWidget(
                  isUpload: false,

                    progressValue: 0.4,
                    widthBorder: 4,
                    iconSize: 15,
                  ),
                )
              : Obx(
                  () => GestureDetector(
                    onTap: () async {
                      playController.play(widget.message);
                    },
                    child: Icon(
                      playController.playAudioId.value == widget.message.id
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: widget.message.fromId == FirebaseController.me.id
                          ? Colors.white
                          : kPrimaryColor,
                    ),
                  ),
                ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 2,
                    color: widget.message.fromId == FirebaseController.me.id
                        ? Colors.white
                        : kPrimaryColor.withOpacity(0.4),
                  ),
                  Positioned(
                    left: 0,
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: widget.message.fromId == FirebaseController.me.id
                            ? Colors.white
                            : kPrimaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            "0.37",
            style: TextStyle(
                fontSize: 12,
                color: widget.message.fromId == FirebaseController.me.id
                    ? Colors.white
                    : null),
          ),
        ],
      ),
    );
  }
}
