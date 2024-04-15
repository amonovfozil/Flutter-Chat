import 'package:flutter/material.dart';
import 'package:flutter_chat/utils/constants.dart';
import 'package:get/get.dart';

class MessageSnack {
  static GetSnackBar customSnack({
    String? title,
    required String errorMessage,
  }) {
    return GetSnackBar(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(5),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      borderRadius: 35,
      barBlur: 1.0,
      icon: const Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 18),
        child: Icon(
          Icons.error_outline,
          size: 40,
          color: Colors.white,
        ),
      ),
      messageText: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          errorMessage,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'sfpro',
          ),
        ),
      ),
    );
  }

  static GetSnackBar errorSnack({
    required String message,
  }) {
    return GetSnackBar(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(5),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      borderRadius: 15,
      barBlur: 1.0,
      backgroundColor: kErrorColor,
      icon: const Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
        child: Icon(
          Icons.error_outline,
          size: 40,
          color: Colors.white,
        ),
      ),
      messageText: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w400,
            fontFamily: 'sfpro',
          ),
        ),
      ),
    );
  }

  static GetSnackBar sucsessSnackBar({
    required String message,
  }) {
    return GetSnackBar(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(5),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(milliseconds: 1500),
      borderRadius: 35,
      barBlur: 1.0,
      backgroundColor: const Color(0xFF3DB6A0),
      icon: const Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
        child: Icon(
          Icons.check_circle_outline_outlined,
          size: 40,
          color: Colors.white,
        ),
      ),
      messageText: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w400,
            fontFamily: 'sfpro',
          ),
        ),
      ),
    );
  }
}
