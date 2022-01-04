import 'package:SuperNinja/data/sharedpreference/user_preferences.dart';
import 'package:SuperNinja/domain/commons/nav_key.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:smartech_flutter_plugin/smartech_plugin.dart';

import 'constant/color.dart';
import 'routes.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await getPEMKeyCert();
  await AppTrackingTransparency.requestTrackingAuthorization();
  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  await SentryFlutter.init(
    (options) {
      options.dsn = dotenv.env['SENTRY_URL'];
    },
    appRunner: () => runApp(MyApp()),
  );
}

Future<void> getPEMKeyCert() async {
  final data = await rootBundle.loadString("assets/certs/certificate.pem");
  NavKey.pemKey = data;
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

    initLocalNotification();
    initFirebase();
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
    return MaterialApp(
      title: "Super Ninja",
      navigatorKey: NavKey.navKey,
      localizationsDelegates: const [FormBuilderLocalizations.delegate],
      theme: ThemeData(
        primaryColor: primary,
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }),
        fontFamily: "Poppins",
        canvasColor: Colors.white,
        focusColor: primary,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: primary,
          selectionColor: primary,
          selectionHandleColor: primary,
        ),
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: primary,
              secondary: primary,
            ),
      ),
      initialRoute: "/",
      routes: routes,
    );
  }

  // ignore: unused_element
  static Future<void> _showNotification(
    int notificationId,
    String notificationTitle,
    String notificationContent,
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

  Future<void> initFirebase() async {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    await FirebaseMessaging.instance.requestPermission(provisional: true);
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      if (token.isNotEmpty) {
        UserPreferences().setFirebaseToken(token);
      }
    });
    await FirebaseMessaging.instance.getToken().then((token) {
      if (token != null) {
        UserPreferences().setFirebaseToken(token);
      }
    });
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessageReceived);
    FirebaseMessaging.onMessage.listen(onMessageReceived);
  }

  Future<void> onMessageReceived(RemoteMessage remoteMessage) async {
    print(remoteMessage.data);
    await _showNotification(
      1,
      remoteMessage.data['title'],
      remoteMessage.data['message'],
      "",
    );
    await SmartechPlugin()
        .handlePushNotification(remoteMessage.data.toString());
    return Future<void>.value();
  }

  Future<void> onBackgroundMessageReceived(RemoteMessage remoteMessage) async {
    print(remoteMessage);
    await _showNotification(
      1,
      remoteMessage.data['title'],
      remoteMessage.data['message'],
      "",
    );
    await SmartechPlugin()
        .handlePushNotification(remoteMessage.data.toString());
    return Future<void>.value();
  }

  void initLocalNotification() {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = IOSInitializationSettings();
    const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }
}
