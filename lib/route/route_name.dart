import 'package:flutter/material.dart';
import 'package:flutter_chat/screens/welcome/welcome_screen.dart';

//route name
const String welcomePage = '/welcome';

Map<String, Widget Function(BuildContext)> routes = {
  welcomePage: (ctx) => const WelcomeScreen(),
};
