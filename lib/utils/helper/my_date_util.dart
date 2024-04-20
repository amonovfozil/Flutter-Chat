import 'package:flutter/material.dart';
import 'package:flutter_chat/logic/firebase/firebase_controller.dart';
import 'package:flutter_chat/models/chat_message.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyDateUtil {
  // for getting formatted time from milliSecondsSinceEpochs String
  static Widget getFormattedTime(
      {required BuildContext context, required MessageModels message}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          DateFormat.Hm().format(
            DateTime.fromMillisecondsSinceEpoch(
              message.sendTime.millisecondsSinceEpoch,
            ),
          ),
          style: const TextStyle(
            height: 1.5,
            fontSize: 10,
          ),
        ),
        const SizedBox(width: 5),
        if (message.fromId == FirebaseController.me.id)
          Icon(
            message.status == MessageStatus.viewed
                ? Icons.done_all
                : Icons.done,
            size: 15,
          )
      ],
    );
  }

  // for getting formatted Day from milliSecondsSinceEpochs String

  static String getFormattedDay(String dateValue) {
    List dateData =
        List.from(dateValue.split("-").map((e) => int.parse(e)).toList());
    DateTime date = DateTime(dateData[0], dateData[1], dateData[2]);
    DateTime today = DateTime.now();
    String formattedDate;
    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      // same day
      formattedDate = "${'Today'.tr}, ${DateFormat.MMMMd().format(date)}";
    } else if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day - 1) {
      formattedDate = "${"Yesterday".tr}, ${DateFormat.MMMMd().format(date)}";
    } else {
      formattedDate = DateFormat.MMMMd().format(date);
    }

    return formattedDate;
  }

  // for getting formatted time for sent & read
  static String getMessageTime(
      {required BuildContext context, required String time}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    final formattedTime = TimeOfDay.fromDateTime(sent).format(context);
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return formattedTime;
    }

    return now.year == sent.year
        ? '$formattedTime - ${sent.day} ${_getMonth(sent)}'
        : '$formattedTime - ${sent.day} ${_getMonth(sent)} ${sent.year}';
  }

  //get last message time (used in chat user card)
  static String getLastMessageTime(
      {required BuildContext context,
      required String time,
      bool showYear = false}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }

    return showYear
        ? '${sent.day} ${_getMonth(sent)} ${sent.year}'
        : '${sent.day} ${_getMonth(sent)}';
  }

  //get formatted last active time of user in chat screen
  static String getLastActiveTime(
      {required BuildContext context, required String lastActive}) {
    final int i = int.tryParse(lastActive) ?? -1;

    //if time is not available then return below statement
    if (i == -1) return 'Last seen not available';

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    // if (time.day == now.day &&
    //     time.month == now.month &&
    //     time.year == time.year) {
    //   return formattedTime;
    //   // return 'Last seen today at $formattedTime';
    // }

    // if ((now.difference(time).inHours / 24).round() == 1) {
    //   return 'Last seen yesterday at $formattedTime';
    // }

    String month = _getMonth(time);

    return ' $formattedTime ${time.day} $month ';
  }

  // get month name from month no. or index
  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'NA';
  }
}
