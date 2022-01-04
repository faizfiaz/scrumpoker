import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:scrumpoker/routes.dart';

import 'constant/color.dart';
import 'data/sharedpreference/user_preferences.dart';
import 'domain/commons/nav_key.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp();

  if ((defaultTargetPlatform == TargetPlatform.iOS) ||
      (defaultTargetPlatform == TargetPlatform.android)) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } else {
    NavKey.isRunningWeb = true;
  }

  // await getPEMKeyCert();
  runApp(Container(
      color: NavKey.isRunningWeb ? primaryTrans : Colors.white,
      child: Center(child: SizedBox(width:NavKey.isRunningWeb ? NavKey.widthWeb : double.infinity,child: MyApp()))));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    if (!NavKey.isRunningWeb) {
      initializeFlutterLocalNotification();
      initializeFirebase();
    }
  }

  Future<dynamic> onSelectNotification(String? payload) async {
    /*Do whatever you want to do on notification click. In this case, I'll show an alert dialog*/
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(payload!),
        content: Text("Payload: $payload"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var startRoute = "/";
    if (NavKey.isRunningWeb) {
      startRoute = "/login";
    }
    return MaterialApp(
      title: "Scrum Poker",
      navigatorKey: NavKey.navKey,
      theme: ThemeData(
          primaryColor: primary,
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          }),
          fontFamily: "NunitoSans",
          canvasColor: Colors.white, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accent)),
      initialRoute: startRoute,
      routes: routes,
    );
  }

  static Future<void> _showNotification(
      int notificationId,
      String? notificationTitle,
      String? notificationContent,
      String payload, {
        String channelId = '1234',
        String channelTitle = 'Android Channel',
        String channelDescription = 'Default Android Channel for notifications',
        Priority notificationPriority = Priority.high,
        Importance notificationImportance = Importance.max,
      }) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelTitle,
      channelDescription: channelDescription,
      playSound: false,
      importance: notificationImportance,
      priority: notificationPriority,
    );
    const iOSPlatformChannelSpecifics =
    IOSNotificationDetails(presentSound: false);
    final platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      notificationTitle,
      notificationContent,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  void initializeFlutterLocalNotification() {
    const initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = IOSInitializationSettings();
    const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  // Create a [AndroidNotificationChannel] for heads up notifications
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  static Future<dynamic> onBackgroundMessage(
      Map<String, dynamic> message) async {
    final jsonData = message["notification"];
    unawaited(_showNotification(1234, jsonData["title"], jsonData["body"], ""));
    return Future<void>.value();
  }

  Future<void> initializeFirebase() async {
    // if (environment.env['CURRENT_ENV'] == "1") {
    //Force Collect Crash if in Production
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    // }
    final _firebaseMessaging = FirebaseMessaging.instance;

    FirebaseMessaging.onMessage.listen((message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      onBackgroundMessage(message.data);
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    unawaited(_firebaseMessaging.getToken().then((value) {
      if (value != null) {
        UserPreferences().setFirebaseToken(value);
      }
    }));

    await _firebaseMessaging.requestPermission(

    );
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
