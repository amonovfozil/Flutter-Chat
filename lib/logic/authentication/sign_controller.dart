import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';

class Signcontroller extends GetxController {
  var box = GetStorage();
  RxBool isSignUp = false.obs;
  static RxBool hasFocus = false.obs;
  TextEditingController nameContrl = TextEditingController();
  TextEditingController mailContrl = TextEditingController();
  TextEditingController passwordContrl = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late UserCredential userCredential;
  sign() async {
    try {
      await (isSignUp.value
          ? _firebaseAuth.createUserWithEmailAndPassword(
              email: mailContrl.text,
              password: passwordContrl.text,
            )
          : _firebaseAuth.signInWithEmailAndPassword(
              email: mailContrl.text,
              password: passwordContrl.text,
            ));
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
