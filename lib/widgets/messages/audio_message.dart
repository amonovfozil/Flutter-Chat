import 'package:flutter_chat/logic/chats/file_controller.dart';
import 'package:flutter_chat/logic/firebase/firebase_controller.dart';
import 'package:flutter_chat/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/utils/helper/my_date_util.dart';
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
  RxDouble downloadIndecator = 0.0.obs;
  bool isMe = false;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        isMe = FileController.playAudioId.value == widget.message.id;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding * 0.75,
                // vertical: kDefaultPadding / 2.5,
              ),
              margin: const EdgeInsets.only(
                top: 10,
                // vertical: kDefaultPadding / 2.5,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: kPrimaryColor.withOpacity(
                    widget.message.fromId == FirebaseController.me.id
                        ? 1
                        : 0.1),
              ),
              child: Row(
                children: [
                  Obx(
                    () => GestureDetector(
                      onTap: () async {
                        if (FileController.getMessageFileUrl(widget.message)
                            .startsWith("https://")) {
                          FileController.downloadFile(
                              widget.message, downloadIndecator);
                        } else {
                          FileController.play(widget.message);
                        }
                      },
                      child: FileController.getMessageFileUrl(widget.message)
                              .startsWith("https://")
                          ? SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressWidget(
                                isUpload: false,
                                progressValue: downloadIndecator.value,
                                widthBorder: 4,
                                iconSize: 15,
                              ),
                            )
                          : Icon(
                              FileController.playAudioId.value ==
                                      widget.message.id
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: widget.message.fromId ==
                                      FirebaseController.me.id
                                  ? Colors.white
                                  : kPrimaryColor,
                            ),
                    ),
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: SliderThemeData(
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 6),
                        trackHeight: 3,
                        thumbColor: Colors.white,
                        activeTrackColor:
                            FirebaseController.me.id == widget.message.fromId
                                ? kContentColorDarkTheme
                                : kPrimaryColor,
                        inactiveTrackColor: Colors.white,
                      ),
                      child: Slider(
                        value: isMe
                            ? FileController.posetion.value.inSeconds.toDouble()
                            : 0.0,
                        max: FileController.duration.value.inSeconds.toDouble(),
                        onChanged: (value) {
                          FileController.player
                              .seek(Duration(seconds: value.toInt()));
                        },
                      ),
                    ),
                  ),
                  if (isMe)
                    Text(
                      "${FileController.durationToString(FileController.posetion.value)} / ${FileController.durationToString(FileController.duration.value)}",
                      style: TextStyle(
                          fontSize: 10,
                          color:
                              widget.message.fromId == FirebaseController.me.id
                                  ? Colors.white
                                  : null),
                    ),
                ],
              ),
            ),
            MyDateUtil.getFormattedTime(
              context: context,
              message: widget.message,
            ),
          ],
        );
      },
    );
  }
}
