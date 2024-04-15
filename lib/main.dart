import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/firebase_options.dart';
import 'package:flutter_chat/route/route_name.dart';
import 'package:flutter_chat/screens/authentication/signin_or_signup_screen.dart';
import 'package:flutter_chat/screens/home/home_screen.dart';
import 'package:flutter_chat/utils/theme.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  runApp(const MyApp());
}

Rx<ThemeMode> theme = ThemeMode.light.obs;

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        title: 'The Flutter chat',
        debugShowCheckedModeBanner: false,
        theme: lightThemeData(context),
        darkTheme: darkThemeData(context),
        themeMode: theme.value,
        // initialRoute: welcomePage,

        home: const Home(),
        routes: routes,
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, AsyncSnapshot<User?> userSnapshot) {
          if (userSnapshot.hasData) {
            return const HomeScreen();
          } else {
            return const SignScreen();
          }
        });
  }
}
