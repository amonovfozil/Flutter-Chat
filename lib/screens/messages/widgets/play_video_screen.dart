import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat/logic/chats/file_controller.dart';
import 'package:flutter_chat/models/chat_message.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../utils/constants.dart';

class PlayVideoScreen extends StatefulWidget {
  final MessageModel message;

  const PlayVideoScreen({super.key, required this.message});

  @override
  State<PlayVideoScreen> createState() => _PlayVideoScreenState();
}

class _PlayVideoScreenState extends State<PlayVideoScreen> {
  Rx<Duration> position = const Duration().obs;
  Rx<Duration> duration = const Duration().obs;
  RxBool isPlay = false.obs;
  late VideoPlayerController _controller;

  @override
  void initState() {
    playVideo();
    super.initState();
  }

  @override
  void dispose() {
    _controller.pause();
    super.dispose();
  }

  playVideo() async {
    position.value = const Duration();
    duration.value = const Duration();

    _controller = FileController.getMessageFileUrl(widget.message)
            .startsWith("https://")
        ? VideoPlayerController.networkUrl(
            Uri.parse(FileController.getMessageFileUrl(widget.message)))
        : VideoPlayerController.file(
            File(FileController.getMessageFileUrl(widget.message)))
      ..initialize();
    _controller.play();
    _controller.addListener(() async {
      duration.value = _controller.value.duration;
      var pos = await _controller.position;
      position.value = pos ?? const Duration();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: VideoPlayer(_controller),
          ),
          Container(
            // width: 150,
            height: 50,
            margin: const EdgeInsets.all(15),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_controller.value.isCompleted) {
                          playVideo();
                        } else if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                      },
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: const BoxDecoration(
                          color: kPrimaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: const SliderThemeData(
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 6),
                          trackHeight: 3,
                          thumbColor: Colors.white,
                          activeTrackColor: kPrimaryColor,
                          inactiveTrackColor: Colors.white,
                        ),
                        child: Slider(
                          value: position.value.inSeconds.toDouble(),
                          max: duration.value.inSeconds.toDouble(),
                          onChanged: (value) async {
                            position.value = Duration(seconds: value.toInt());
                            await _controller
                                .seekTo(Duration(seconds: value.toInt()));
                          },
                        ),
                      ),
                    ),
                    Text(
                      "${FileController.durationToString(position.value, false)} / ${FileController.durationToString(position.value, false)}",
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
