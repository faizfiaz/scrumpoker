import 'dart:async';

import 'package:SuperNinja/constant/color.dart';
import 'package:SuperNinja/constant/images.dart';
import 'package:SuperNinja/domain/usecases/user/user_usecase.dart';
import 'package:SuperNinja/ui/pages/home/home_screen.dart';
import 'package:SuperNinja/ui/pages/intro/intro_screen.dart';
import 'package:SuperNinja/ui/widgets/multilanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartech_flutter_plugin/smartech_plugin.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    final prefs = SharedPreferences.getInstance();
    var languages = Languages.id;
    prefs.then((value) {
      final currentLanguage = value.getString(langKey);
      if (currentLanguage != null) languages = currentLanguage;
      final languageSetting =
          MultiLanguage().setLanguage(path: languages, context: context);
      languageSetting.then((value) {
        if (value) {
          startTimer();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: Image.asset(
              logoSuperNinja,
              fit: BoxFit.fill,
              height: 300,
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.all(20),
            child: Text(
              "App Version ${dotenv.env['VERSION_NAME']!}${dotenv.env['CURRENT_ENV'] == "0" ? "-DEV" : ""}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 9, fontWeight: FontWeight.w600, color: primary),
            ),
          ),
        ],
      ),
    );
  }

  // ignore: avoid_void_async
  void startTimer() async {
    const duration = Duration(seconds: 3);
    Timer(duration, navigatePage);
  }

  Future<void> navigatePage() async {
    final usecase = UserUsecase.empty();
    final alreadyLogin = await usecase.hasToken();
    if (alreadyLogin == true) {
      final userData = await usecase.fetchUserData();
      if (userData != null) {
        if (userData.id != null) {
          // ignore: unawaited_futures
          SmartechPlugin().setUserIdentity(userData.id.toString());
        }
      }
    }
    if (await usecase.hasSeenIntro() == true) {
      await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                    0,
                    alreadyLogin: alreadyLogin,
                  )),
          (r) => false);
    } else {
      await Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => IntroScreen()), (r) => false);
    }
  }
}
