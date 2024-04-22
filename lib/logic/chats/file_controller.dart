import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat/logic/firebase/firebase_api.dart';
import 'package:flutter_chat/models/chat_message.dart';
import 'package:flutter_chat/models/chat_models.dart';
import 'package:flutter_chat/utils/helper/directory_path.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

class FileController extends GetxController {
  // audio message
  static final player = AudioPlayer();
  static RxString playAudioId = "".obs;
  static Rx<Duration> duration = const Duration(seconds: 0).obs;
  static Rx<Duration> posetion = const Duration(seconds: 0).obs;

  static Future<void> play(MessageModel message) async {
    player.pause();
    if (message.id != playAudioId.value) {
      player.play(
          FileController.getMessageFileUrl(message).startsWith("https://")
              ? UrlSource(FileController.getMessageFileUrl(message))
              : DeviceFileSource(FileController.getMessageFileUrl(message)));
      playAudioId.value = message.id;
    } else {
      playAudioId.value = "";
    }
    FileController.player.onDurationChanged.listen(
      (value) {
        duration.value = value;
      },
    );
    FileController.player.onPositionChanged.listen(
      (value) {
        posetion.value = value;
      },
    );
  }

  static String durationToString(Duration duration, bool isAudio) {
    return duration.toString().split(".")[0].substring(isAudio ? 2 : 0);
  }

  static Rx<MessageType> uploadFileType = MessageType.text.obs;
  static RxDouble uploadIndecator = 0.0.obs;
  static RxString filename = "".obs;

//upload File message

  static Future<void> uploadChatFile(ChatModel chat, File file) async {
    filename.value = basename(file.path);
    uploadIndecator = 0.1.obs;
    //getting image file extension
    final ext = file.path.split('.').last;
    uploadFileType.value = fileType(ext);

    //storage file ref with path
    final ref =
        FirebaseAPI.storage.ref(FirebaseAPI.user.uid).child('chat_file');

    ref
        .putFile(file, SettableMetadata(contentType: basename(file.path)))
        .snapshotEvents
        .listen((data) {
      uploadIndecator.value = data.bytesTransferred / data.totalBytes;
      log('Data Transferred: ${data.bytesTransferred / data.totalBytes} kb');
    });

    String fileUrl = await ref.getDownloadURL();

    FileModel uploadFile = FileModel(
        name: basename(file.path), url: fileUrl, fromAdress: file.path);
    uploadFileType.value = MessageType.text;
    //updating image in firestore database
    await FirebaseAPI.sendMessage(chat, fileType(ext), file: uploadFile);
  }

// Identify the file type
  static MessageType fileType(String ext) {
    switch (ext.toLowerCase()) {
      case "jpeg":
        return MessageType.image;
      case "jpg":
        return MessageType.image;
      case "png":
        return MessageType.image;
      case "mp4":
        return MessageType.video;
      case "mp3":
        return MessageType.audio;
      case "pdf":
        return MessageType.pdf;

      default:
        return MessageType.text;
    }
  }

// download File maessage
  static Future downloadFile(
      MessageModel msg, RxDouble progressIndecator) async {
    progressIndecator.value = 0.1;
    final path = await DirectoryPath.getPath();
    var savePath = '$path/${msg.file!.name}';
    var dio = Dio();
    dio.interceptors.add(LogInterceptor());
    try {
      var response = await dio.get(
        msg.file!.url,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            progressIndecator.value = (received / total * 100);
            log('${(received / total * 100).toStringAsFixed(0)}%');
          }
        },
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
      var file = File(savePath);

      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      msg.file!.dwnUrl = savePath;
      await updateMessageFile(msg);

      log("DOWNLOAD URL ${msg.file!.dwnUrl}");
      await raf.close();
      progressIndecator.value = 0.0;
    } catch (e) {
      log(e.toString());
    }
  }

// Update message
  static Future<void> updateMessageFile(MessageModel message) async {
    log("UPDATE MESSAGe======= ${message.toJson()}");
    await FirebaseAPI.firestore
        .collection('messages')
        .doc(message.chatId)
        .collection("my_messages")
        .doc(message.id)
        .update(message.toJson());
  }

// select file message url
  static String getMessageFileUrl(MessageModel message) {
    if (FirebaseAPI.me.id == message.fromId) {
      return message.file!.fromAdress!;
    } else if (message.file!.dwnUrl != null) {
      return message.file!.dwnUrl!;
    } else {
      return message.file!.url;
    }
  }

//message Edit part

  RxBool isSelect = false.obs;
  RxList<MessageModel> selectMessages = <MessageModel>[].obs;
}
