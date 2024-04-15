import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/logic/firebase/firebase_controller.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';

class Signcontroller extends GetxController {
  var box = GetStorage();
  RxBool isSignUp = false.obs;
  static RxBool hasFocus = false.obs;
  static TextEditingController nameContrl = TextEditingController();
  static TextEditingController mailContrl = TextEditingController();
  static TextEditingController passwordContrl = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late UserCredential userCredential;
  sign() async {
    try {
      if (isSignUp.value) {
        userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: mailContrl.text,
          password: passwordContrl.text,
        );
        FirebaseController.createUser();
      } else {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: mailContrl.text,
          password: passwordContrl.text,
        );
      }
    } on FirebaseAuthException catch (e) {
      log("Firebasesign  Error ${e.code}");
      log("Firebasesign  Error $e");

      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      log("sign Error $e");
    }
  }
}
