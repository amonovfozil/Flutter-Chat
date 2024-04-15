import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat/logic/authentication/sign_controller.dart';
import 'package:flutter_chat/models/chat_message.dart';
import 'package:flutter_chat/models/chat_models.dart';
import 'package:flutter_chat/models/user_models.dart';
import 'package:get/get.dart';

class FirebaseController extends GetxController {
  static Dio dio = Dio();

  // Authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // Firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //Firebase database
  static FirebaseDatabase database = FirebaseDatabase.instance;

  // Firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  // Firebase messaging (Push Notification)
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;
  // for storing self information

// to return current user
  static User get user => auth.currentUser!;

  static UserModel me = UserModel(
    id: user.uid,
    name: user.displayName.toString().obs,
    email: user.email.toString(),
    password: "",
    image: (user.photoURL ?? "").obs,
    createdAt: DateTime.now().toIso8601String(),
    isOnline: false,
    lastActive: '',
    pushToken: '',
  );

  // get current user info
  static Future<void> getSelfInfo() async {
    firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = UserModel.fromJson(user.data()!);
        await getFirebaseMessagingToken();

        //for setting user status to active
        FirebaseController.updateActiveStatus(true);
        log('My Data: ${user.data()}');
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

// update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

// for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now();

    final newUser = UserModel(
      id: user.uid,
      name: Signcontroller.nameContrl.text.obs,
      email: Signcontroller.mailContrl.text,
      password: Signcontroller.passwordContrl.text,
      image: (user.photoURL ?? "").obs,
      createdAt: time.toIso8601String(),
      isOnline: false,
      lastActive: time.millisecondsSinceEpoch.toString(),
      pushToken: '',
    );

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(newUser.toJson());
  }

// get all contacts
  static RxList<UserModel> contacts = <UserModel>[].obs;
  static Future<void> getAllContact() async {
    var list = await firestore.collection('users').get();
    contacts.value = List<UserModel>.from(list.docs
        .map((queryData) => UserModel.fromJson(queryData.data()))
        .toList());
    log("contact 222 : $contacts");
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> streamAllContact() {
    return firestore.collection('users').snapshots();
  }

// update profile picture of user
  static Future<void> updateProfilePicture(File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;
    log('Extension: $ext');

    //storage file ref with path
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    me.image.value = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': me.image.value});
    await getSelfInfo();
  }

// for adding an chat user for our conversation
  static Future creatUserChat(UserModel user) async {
    final data = await firestore
        .collection('chats')
        .doc(me.id)
        .collection("my_chats")
        .where('users', arrayContains: user.toJson())
        .get();

    log('data: ${data.docs}');
    if (data.docs.isEmpty) {
      ChatModel newChat = ChatModel(
        id: "${me.id}&${user.id}",
        lastMessage: "",
        users: [user, me],
        type: ChatType.user,
      );
      firestore
          .collection('chats')
          .doc(me.id)
          .collection("my_chats")
          .doc(newChat.id)
          .set(newChat.toJson());
      firestore
          .collection('chats')
          .doc(user.id)
          .collection("my_chats")
          .doc(newChat.id)
          .set(newChat.toJson());
    }
  }

  // for getting id's of known users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllChats() {
    return firestore
        .collection('chats')
        .doc(user.uid)
        .collection('my_chats')
        .snapshots();
  }

  // for getting firebase messaging token
  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        log('Push Token: $t');
      }
    });
  }

  // for sending push notification
  static Future<void> sendPushNotification(
      UserModel chatUser, String msg) async {
    try {
      final body = {
        "to": chatUser.pushToken,
        "notification": {
          "title": me.name, //our name should be send
          "body": msg,
          "android_channel_id": "chats"
        },
        // "data": {
        //   "some_data": "User ID: ${me.id}",
        // },
      };

      var res = await dio.post('https://fcm.googleapis.com/fcm/send',
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAAQ0Bf7ZA:APA91bGd5IN5v43yedFDo86WiSuyTERjmlr4tyekbw_YW6JrdLFblZcbHdgjDmogWLJ7VD65KGgVbETS0Px7LnKk8NdAz4Z-AsHRp9WoVfArA5cNpfMKcjh_MQI-z96XQk5oIDUwx8D1'
          }),
          data: jsonEncode(body));
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.data}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }

  // for checking if user exists or not?
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  // // for getting all users from firestore database
  // static Stream<QuerySnapshot<Map<String, dynamic>>> getAllChats(
  //     List<String> userIds) {
  //   log('\nUserIds: $userIds');

  //   return firestore
  //       .collection('chat')
  //       .where('id',
  //           whereIn: userIds.isEmpty
  //               ? ['']
  //               : userIds) //because empty list throws an error
  //       // .where('id', isNotEqualTo: user.uid)
  //       .snapshots();
  // }

  // // for updating user information
  // static Future<void> updateUserInfo() async {
  //   await firestore.collection('users').doc(user.uid).update({
  //     'name': me.name,
  //     // 'about': me.about,
  //   });
  // }

  // for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      UserModel chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  ///************** Chat Screen Related APIs **************

  // chats (collection) --> conversation_id (doc) --> messages (collection) --> message (doc)

  // useful for getting conversation id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      UserModel user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // for sending message
  static Future<void> sendMessage(UserModel chatUser, String msg,
      MessageStatus status, MessageType type) async {
    //message sending time (also used as id)
    // final time = DateTime.now().millisecondsSinceEpoch.toString();
    final time = DateTime.now();

    //message to send
    final MessageModels message = MessageModels(
      id: chatUser.id,
      msg: msg,
      status: status,
      type: type,
      fromId: user.uid,
      sendTime: time,
    );

    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref
        .doc(time.millisecondsSinceEpoch.toString())
        .set(message.toJson())
        .then((value) => sendPushNotification(
            chatUser, type == MessageType.text ? msg : 'image'));
  }

  //update read status of message
  static Future<void> updateMessageReadStatus(MessageModels message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sendTime.millisecondsSinceEpoch.toString())
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  //get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      UserModel user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  //send chat image
  static Future<void> sendChatImage(UserModel chatUser, File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(
        chatUser, imageUrl, MessageStatus.notView, MessageType.image);
  }

  //delete message
  static Future<void> deleteMessage(MessageModels message) async {
    await firestore
        .collection('chats/${getConversationID(message.id)}/messages/')
        .doc(message.sendTime.millisecondsSinceEpoch.toString())
        .delete();

    if (message.type == MessageType.image) {
      await storage.refFromURL(message.msg!).delete();
    }
  }

  //update message
  static Future<void> updateMessage(
      MessageModels message, String updatedMsg) async {
    await firestore
        .collection('chats/${getConversationID(message.id)}/messages/')
        .doc(message.sendTime.millisecondsSinceEpoch.toString())
        .update({'msg': updatedMsg});
  }
}
