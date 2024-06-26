import 'package:flutter/cupertino.dart';
import 'package:flutter_chat/logic/authentication/sign_controller.dart';
import 'package:flutter_chat/main.dart';
import 'package:flutter_chat/screens/components/custom_text_field.dart';
import 'package:flutter_chat/screens/components/primary_button.dart';
import 'package:flutter_chat/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({super.key});

  @override
  State<SignScreen> createState() => _SigninOrSignupScreenState();
}

class _SigninOrSignupScreenState extends State<SignScreen> {
  final _formKey = GlobalKey<FormState>();
  Signcontroller signcontroller = Get.put(Signcontroller());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        // resizeToAvoidBottomInset: false
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Spacer(flex: 2),
                Image.asset(
                  theme.value == ThemeMode.light
                      ? "dev_assets/light.gif"
                      : "dev_assets/dark.gif",
                  height: 250,
                ),
                const Spacer(),
                // PrimaryButton(
                //   text: "Sign In",
                //   press: () => Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => const ChatsScreen(),
                //     ),
                //   ),
                // ),
                Visibility(
                  visible: signcontroller.isSignUp.value,
                  child: CustomTextField(
                    labelText: "name",
                    icon: CupertinoIcons.person,
                    controller: Signcontroller.nameContrl,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return "Maydonni to'ldiring";
                      } else {
                        return "";
                      }
                    },
                  ),
                ),
                const SizedBox(height: kDefaultPadding),
                CustomTextField(
                  labelText: "mail",
                  icon: CupertinoIcons.mail,
                  controller: Signcontroller.mailContrl,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "Maydonni to'ldiring";
                    } else {
                      return "";
                    }
                  },
                ),
                const SizedBox(height: kDefaultPadding),
                CustomTextField(
                  labelText: "Password",
                  icon: Icons.password,
                  controller: Signcontroller.passwordContrl,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "Maydonni to'ldiring";
                    } else {
                      return "";
                    }
                  },
                ),
                const SizedBox(height: kDefaultPadding * 1.5),
                PrimaryButton(
                  color: signcontroller.isSignUp.value
                      ? kSecondaryColor
                      : kPrimaryColor,
                  text: signcontroller.isSignUp.value ? "Sign Up" : "Sign In",
                  press: () {
                    if (_formKey.currentState!.validate()) {
                      signcontroller.sign();
                    }
                  },
                ),
                const SizedBox(height: kDefaultPadding),
                TextButton(
                  onPressed: () {
                    signcontroller.isSignUp.toggle();
                  },
                  child: Text(
                    signcontroller.isSignUp.value ? "Sign In" : "Sign Up",
                    style: TextStyle(
                      color: signcontroller.isSignUp.value
                          ? kPrimaryColor
                          : kSecondaryColor,
                    ),
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
